//
//  AudioPlayerManager.swift
//  AudioRecorderApp
//
//  Created by Jestin Saji on 25/05/26.
//


import Foundation
import AVFoundation

class AudioPlayerManager: NSObject, AVAudioPlayerDelegate {
    
    var player: AVAudioPlayer?
    
    var timer: Timer?
    
    var currentTime: ((Double)->Void)?
    
    var finishedPlaying:(()->Void)?
    
    var currentURL:URL?
    
    
    func play(url: URL) {
        
        // Resume existing audio
        
        if currentURL == url &&
            player != nil {
            
            player?.play()
            
            startTimer()
            
            return
        }
        
        
        do {
            
            currentURL = url
            
            player =
            try AVAudioPlayer(
                contentsOf:url
            )
            
            player?.delegate = self
            
            player?.play()
            
            startTimer()
            
        } catch {
            
            print(error)
        }
    }
    
    
    func startTimer() {
        
        timer?.invalidate()
        
        timer =
        Timer.scheduledTimer(
            withTimeInterval:0.1,
            repeats:true
        ) { _ in
            
            self.currentTime?(
                self.player?.currentTime
                ?? 0
            )
        }
    }
    
    
    func pause() {
        
        player?.pause()
        
        timer?.invalidate()
    }
    
    
    func stop() {
        
        player?.stop()
        
        player?.currentTime = 0
        
        currentURL = nil
        
        timer?.invalidate()
    }
    
    
    func seek(
        value: Double
    ) {
        
        player?.currentTime =
        value
    }
    
    
    func duration()
    -> Double {
        
        player?.duration ?? 0
    }
    
    
    func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer,
        successfully flag: Bool
    ) {
        
        currentURL = nil
        
        timer?.invalidate()
        
        finishedPlaying?()
    }
}
