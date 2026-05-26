//
//  RecorderPopupView.swift
//  AudioRecorderApp
//
//  Created by Jestin Saji on 25/05/26.
//


import SwiftUI

struct RecorderPopupView: View {
    
    @Binding var show: Bool
    @State var isPlaying = false
    
    let recording: Recording?
    
    var body: some View {
        
        VStack(spacing:20) {
            
            HStack {
                
                Spacer()
                
                Button {
                    show = false
                } label: {
                    
                    Image(systemName:"xmark")
                }
            }
            
            
            WaveformView(
                samples:
                    Array(repeating: 0.4, count: 30)
            )
            
            HStack(spacing:20) {
                
                Button {
                    
                    isPlaying.toggle()
                    
                } label: {
                    
                    Image(
                        systemName:
                            isPlaying ?
                        "pause.fill"
                        :
                        "play.fill"
                    )
                    .font(.title)
                }
                
                Text("02:18")
                    .font(.title2)
            }
            
        }
        .padding()
        .background(.white)
        .cornerRadius(30)
        .shadow(radius:10)
        .padding()
    }
}
