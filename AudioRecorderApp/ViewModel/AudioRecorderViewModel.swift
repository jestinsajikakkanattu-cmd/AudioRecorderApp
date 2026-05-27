//
//  AudioRecorderViewModel.swift
//  AudioRecorderApp
//
//  Created by Jestin Saji on 25/05/26.
//

import Foundation
import Observation
import AVFoundation
import SwiftUI

@Observable
class AudioRecorderViewModel {
    
    var isRecording = false
    var recordings:[Recording] = []

    var waveform:[CGFloat] = []

    var showRecorderPopup = false
    var selectedRecording: Recording?

    var editingId: UUID?
    var editedName = ""

    let recorderManager = AudioRecorderManager()
    let playerManager = AudioPlayerManager()

    var showSheet = false

    var currentTime = "00:00"

    var timer: Timer?

    var isPlaying = false

    var progress = 0.0
    var duration = 0.0
    
    var showAlert = false
    var alertMessage = ""
    
    var showDeleteAlert = false
    var recordingToDelete: Recording?
    
    var isPaused = false
    
    
    init() {
        
        loadRecordings()
        
        
        recorderManager.audioLevel = { level in
            
            DispatchQueue.main.async {
                
                self.waveform.append(level)
                
                if self.waveform.count > 50 {
                    self.waveform.removeFirst()
                }
            }
        }
        
        
        playerManager.currentTime = { time in
            
            DispatchQueue.main.async {
                
                self.progress = time
                
                let minute = Int(time) / 60
                let second = Int(time) % 60
                
                self.currentTime =
                String(
                    format: "%02d:%02d",
                    minute,
                    second
                )
            }
        }
        
        playerManager.finishedPlaying = {
            
            DispatchQueue.main.async {
                
                self.isPlaying = false
                
                self.progress = 0
                
                self.currentTime = "00:00"
            }
        }
    }
    
    
    // MARK: Recording
    
    func pauseRecording() {
        
        recorderManager.audioRecorder?.pause()
        
        timer?.invalidate()
        
        isPlaying = false
    }


    func resumeRecording() {
        
        recorderManager.audioRecorder?.record()
        
        startTimer()
        
        isPlaying = true
    }

    func pauseResumeRecording() {
        
        recorderManager.pauseResumeRecording()
        
        isPaused.toggle()
    }
    
    func startTimer() {
        
        var seconds =
        (Int(currentTime.prefix(2)) ?? 0) * 60
        +
        (Int(currentTime.suffix(2)) ?? 0)
        
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(
            withTimeInterval:1,
            repeats:true
        ) { _ in
            
            guard self.isPlaying
            else {
                return
            }
            
            
            seconds += 1
            
            let minute =
            seconds / 60
            
            let second =
            seconds % 60
            
            
            self.currentTime =
            String(
                format:"%02d:%02d",
                minute,
                second
            )
        }
    }

    
    func stopTimer() {
        
        timer?.invalidate()
        
        currentTime = "00:00"
    }

    func stopPlaying() {
        
        playerManager.stop()
        
        isPlaying = false
        
        progress = 0
        
        currentTime = "00:00"
    }
    
    func recordButtonTapped() {
        
        isRecording
        ?
        stopRecording()
        :
        startRecording()
    }


    func startRecording() {
        
        recorderManager.requestPermission { allowed in
            
            if allowed {
                
                self.waveform.removeAll()
                
                self.showSheet = true
                
                self.isPlaying = true
                
                self.recorderManager.startRecording()
                
                self.startTimer()
                
                self.isRecording = true
            }
        }
    }


    func stopRecording() {
        
        recorderManager.stopRecording()
        
        stopTimer()
        
        isPlaying = false
        
        isRecording = false
        
        showSheet = false
        
        loadRecordings()
    }
    
    
    // MARK: Playback
    
    
    func playRecording(_ recording: Recording) {
        
        selectedRecording = recording
        
        playerManager.play(
            url: recording.fileURL
        )
        
        duration =
        playerManager.duration()
        
        isPlaying = true
    }


    func pausePlaying() {
        
        playerManager.pause()
        
        isPlaying = false
    }

    
    // MARK: Files
    
    
    func loadRecordings() {
        
        recordings.removeAll()
        
        let path =
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        
        do {
            
            let files =
            try FileManager.default
                .contentsOfDirectory(
                    at: path,
                    includingPropertiesForKeys: [
                        .creationDateKey
                    ]
                )
                .filter {
                    $0.pathExtension == "m4a"
                }
            
            
            let sortedFiles =
            files.sorted {
                
                let date1 =
                try? $0.resourceValues(
                    forKeys:[.creationDateKey]
                ).creationDate
                
                
                let date2 =
                try? $1.resourceValues(
                    forKeys:[.creationDateKey]
                ).creationDate
                
                
                return date1 ?? Date()
                >
                date2 ?? Date()
            }
            
            
            for (index,file)
            in sortedFiles.enumerated() {
                
                let player =
                try AVAudioPlayer(
                    contentsOf: file
                )
                
                let date =
                try file.resourceValues(
                    forKeys:[.creationDateKey]
                ).creationDate
                
                
                recordings.append(
                    Recording(
                        fileURL: file,
                        title: file.deletingPathExtension()
                                   .lastPathComponent,
                        duration: player.duration,
                        date: date ?? Date()
                    )
                )
            }
            
        } catch {
            
            print(error)
        }
    }

    
    func deleteRecording(
        _ recording: Recording
    ) {
        
        do {
            
            try FileManager.default
                .removeItem(
                    at: recording.fileURL
                )
            
            loadRecordings()
            
        } catch {
            
            print(error)
        }
    }

    
    func startEditing(
        _ recording: Recording
    ) {
        
        editingId = recording.id
        
        editedName =
        recording.title
    }

    
    func saveEditedName(
        _ recording: Recording
    ) {
        
        let trimmedName =
        editedName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        
        
        if trimmedName.isEmpty {
            
            editingId = nil
            return
        }
        
        
        let exists =
        recordings.contains {
            
            $0.title.lowercased()
            ==
            trimmedName.lowercased()
            &&
            $0.id != recording.id
        }
        
        
        if exists {
            
            alertMessage =
            "Name already exists"
            
            showAlert = true
            
            return
        }
        
        
        do {
            
            let folder =
            recording.fileURL
                .deletingLastPathComponent()
            
            let newURL =
            folder.appendingPathComponent(
                "\(trimmedName).m4a"
            )
            
            
            try FileManager.default.moveItem(
                at: recording.fileURL,
                to: newURL
            )
            
            loadRecordings()
            
        } catch {
            
            print(error)
        }
        
        editingId = nil
    }
    func seekAudio() {
        
        playerManager.seek(
            value: progress
        )
        
        if isPlaying {
            
            playerManager.player?.play()
        }
    }
}
