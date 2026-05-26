//
//  RecordingSheetView.swift
//  AudioRecorderApp
//
//  Created by Jestin Saji on 25/05/26.
//


import SwiftUI

struct RecordingSheetView: View {
    
    @Binding var showSheet: Bool
    
    var isRecording: Bool
    @Binding var isPlaying: Bool
    
    var time: String
    
    @Binding var progress: Double
    var duration: Double
    
    var waveform:[CGFloat]
    
    var playPauseAction:()->Void
    var doneAction:(()->Void)?
    var closeAction:(()->Void)?
    
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            
            VStack(spacing:20) {
                
                
                // Top Button
                
                if isRecording {
                    
                    ZStack {
                        
                        Circle()
                            .fill(.white)
                            .frame(
                                width:30,
                                height:30
                            )
                            .shadow(
                                color:.black.opacity(0.1),
                                radius:6,
                                y:3
                            )
                        
                        
                        Image(
                            systemName:"chevron.up"
                        )
                        .font(
                            .system(
                                size:14,
                                weight:.bold
                            )
                        )
                        .foregroundColor(
                            .gray
                        )
                    }
                    .offset(y:-30)
                    
                } else {
                    
                    HStack {
                        
                        Spacer()
                        
                        Button {
                            
                            closeAction?()
                            showSheet = false
                            
                        } label: {
                            
                            Image(
                                systemName:"xmark"
                            )
                            .font(
                                .headline
                            )
                            .foregroundColor(
                                .black
                            )
                        }
                    }
                }
                
                
                // Main Container
                
                VStack(spacing:20) {
                    
                    
                    // Recording UI
                    
                    if isRecording {
                        
                        ZStack(
                            alignment:.center
                        ) {
                            
                            RoundedRectangle(
                                cornerRadius:35
                            )
                            .fill(
                                Color.gray.opacity(
                                    0.1
                                )
                            )
                            .frame(
                                height:60
                            )
                            
                            
                            SmoothWaveView(
                                samples: waveform
                            )
                            .frame(
                                height:60
                            )
                            
                            
                            HStack(
                                spacing:15
                            ) {
                                
                                Button {
                                    
                                    playPauseAction()
                                    
                                } label: {
                                    
                                    Image(
                                        systemName:
                                        isPlaying
                                        ?
                                        "pause.fill"
                                        :
                                        "play.fill"
                                    )
                                    .font(
                                        .title2
                                    )
                                    .foregroundColor(
                                        .black
                                    )
                                }
                                
                                
                                Text(
                                    time
                                )
                                .font(
                                    .system(
                                        size:20,
                                        weight:.bold
                                    )
                                )
                            }
                        }
                    }
                    
                    
                    // Playback
                    
                    if !isRecording {
                        
                        VStack(
                            spacing:15
                        ) {
                            
                            HStack(
                                spacing:20
                            ) {
                                
                                Button {
                                    
                                    playPauseAction()
                                    
                                } label: {
                                    
                                    Image(
                                        systemName:
                                        isPlaying
                                        ?
                                        "pause.fill"
                                        :
                                        "play.fill"
                                    )
                                    .font(
                                        .title
                                    )
                                }
                                
                                
                                Text(
                                    time
                                )
                                .font(
                                    .title2
                                )
                                .fontWeight(
                                    .bold
                                )
                            }
                            
                            
                            Slider(
                                value:$progress,
                                in:0...max(
                                    duration,
                                    1
                                ),
                                onEditingChanged: { editing in
                                    
                                    if !editing {
                                        
                                        playPauseAction()
                                    }
                                }
                            )
                        }
                    }
                    
                    
                    // Done Button
                    
                    if isRecording {
                        
                        Button {
                            
                            doneAction?()
                            showSheet = false
                            
                        } label: {
                            
                            HStack {
                                
                                Image(
                                    systemName:
                                    "checkmark"
                                )
                                
                                Text(
                                    "Done"
                                )
                                .fontWeight(
                                    .bold
                                )
                            }
                            .foregroundColor(
                                .green
                            )
                            .frame(
                                maxWidth:.infinity
                            )
                            .padding()
                            .background(
                                Color.green.opacity(
                                    0.15
                                )
                            )
                            .cornerRadius(
                                35
                            )
                        }
                    }
                }
            }
            .padding(.top,20)
            .padding(.horizontal)
            .padding(.bottom)
            .background(
                .white
            )
            .overlay(
                RoundedRectangle(
                    cornerRadius:30
                )
                .stroke(
                    Color.gray.opacity(0.15),
                    lineWidth:1.5
                )
            )
            .cornerRadius(
                30
            )// add if shadow need
//            .cornerRadius(
//                30
//            )
//            .shadow(
//                radius:5
//            )
            .padding(
                .horizontal,
                20
            )
            .padding(
                .bottom,
                10
            )
        }
    }
}
