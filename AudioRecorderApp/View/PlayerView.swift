//
//  PlayerView.swift
//  AudioRecorderApp
//
//  Created by Jestin Saji on 25/05/26.
//


import SwiftUI

struct PlayerView: View {
    
    let recording: Recording
    
    @State var playerManager = AudioPlayerManager()
    
    @State var isPlaying = false
    @State var progress = 0.0
    
    var body: some View {
        
        VStack(spacing:30) {
            
            Spacer()
            
            
            Image(systemName: "waveform.circle.fill")
                .font(.system(size:100))
            
            
            Text(recording.title)
                .font(.title2)
                .fontWeight(.bold)
            
            
            VStack {
                
                Slider(
                    value: $progress,
                    in: 0...max(
                        playerManager.duration(),
                        1
                    )
                ) { editing in
                    
                    if !editing {
                        
                        playerManager.seek(
                            value: progress
                        )
                    }
                }
                
                
                HStack {
                    
                    Text(
                        "\(Int(progress)) s"
                    )
                    
                    Spacer()
                    
                    Text(
                        "\(Int(playerManager.duration())) s"
                    )
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            
            
            Button {
                
                if isPlaying {
                    
                    playerManager.pause()
                    
                } else {
                    
                    playerManager.play(
                        url: recording.fileURL
                    )
                }
                
                isPlaying.toggle()
                
            } label: {
                
                Image(
                    systemName:
                        isPlaying
                    ? "pause.circle.fill"
                    : "play.circle.fill"
                )
                .font(.system(size:70))
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            
            playerManager.currentTime = { time in
                
                DispatchQueue.main.async {
                    
                    progress = time
                }
            }
        }
    }
}
