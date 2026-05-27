//
//  AudioRecorderManager.swift
//  AudioRecorderApp
//
//  Created by Jestin Saji on 25/05/26.
//


import Foundation
import AVFoundation

class AudioRecorderManager: NSObject {
    
    var audioRecorder: AVAudioRecorder?
    var timer: Timer?
    
    var audioLevel: ((CGFloat) -> Void)?
    
    func requestPermission(completion: @escaping(Bool)->Void) {
        
        AVAudioSession.sharedInstance()
            .requestRecordPermission { allowed in
                
                DispatchQueue.main.async {
                    completion(allowed)
                }
            }
    }
    
    
    func startRecording() {
        
        do {
            
            let session = AVAudioSession.sharedInstance()
            
            try session.setCategory(
                .playAndRecord,
                mode:.default,
                options:[.defaultToSpeaker]
            )
            try session.setActive(true)
            
            let fileName = "Recording-\(Date().timeIntervalSince1970).m4a"
            
            let fileURL = FileManager.default
                .urls(for: .documentDirectory,
                      in: .userDomainMask)[0]
                .appendingPathComponent(fileName)
            
            let settings:[String:Any] = [
                AVFormatIDKey:kAudioFormatMPEG4AAC,
                AVSampleRateKey:12000,
                AVNumberOfChannelsKey:1
            ]
            
            audioRecorder = try AVAudioRecorder(
                url: fileURL,
                settings: settings
            )
            
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            
            
            timer = Timer.scheduledTimer(
                withTimeInterval: 0.03,
                repeats: true
            ) { _ in
                
                self.audioRecorder?.updateMeters()
                
                let power = self.audioRecorder?
                    .averagePower(forChannel: 0) ?? -60
                
                
                let level = max(
                    0.05,
                    CGFloat((power + 60) / 60)
                )
                
                self.audioLevel?(level)
            }
            
        } catch {
            print(error)
        }
    }
    
    
    func stopRecording() {
        
        timer?.invalidate()
        audioRecorder?.stop()
    }
    
    func pauseResumeRecording() {
        
        guard let recorder =
        audioRecorder
        else {
            return
        }
        
        
        if recorder.isRecording {
            
            recorder.pause()
            
            timer?.invalidate()
            
        } else {
            
            recorder.record()
            
            
            timer = Timer.scheduledTimer(
                withTimeInterval:0.03,
                repeats:true
            ) { _ in
                
                self.audioRecorder?.updateMeters()
                
                let power =
                self.audioRecorder?
                    .averagePower(
                        forChannel:0
                    ) ?? -60
                
                
                let level =
                max(
                    0.05,
                    CGFloat(
                        (power+60)/60
                    )
                )
                
                self.audioLevel?(
                    level
                )
            }
        }
    }
}
