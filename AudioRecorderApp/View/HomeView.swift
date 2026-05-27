//
//  HomeView.swift
//  AudioRecorderApp
//
//  Created by Jestin Saji on 25/05/26.
//


import SwiftUI

struct HomeView: View {
    
    @State var viewModel = AudioRecorderViewModel()
    
    var body: some View {
        
        ZStack(alignment:.bottom) {
            
            VStack(
                alignment:.leading,
                spacing:20
            ) {
                
                // Top
                
                HStack {
                    
                    Text("My Recordings")
                        .font(
                            .system(
                                size:38,
                                weight:.bold
                            )
                        )
                    
                    Spacer()
                    
                    Image(
                        systemName:"plus"
                    )
                    .font(.title2)
                    
                    Image(
                        systemName:"calendar"
                    )
                    .font(.title2)
                    
                    Image(
                        systemName:"gearshape"
                    )
                    .font(.title2)
                }
                
                
                // Search
                
                HStack {
                    
                    Image(
                        systemName:
                        "magnifyingglass"
                    )
                    .foregroundColor(
                        .gray
                    )
                    
                    Text(
                        "Search"
                    )
                    .foregroundColor(
                        .gray
                    )
                    
                    Spacer()
                }
                .padding()
                .background(
                    Color.gray.opacity(
                        0.1
                    )
                )
                .cornerRadius(
                    25
                )
                
                
                // No data
                
                if viewModel.recordings.isEmpty {
                    
                    Spacer()
                    
                    VStack(
                        spacing:15
                    ) {
                        
                        Image(
                            systemName:
                            "waveform"
                        )
                        .font(
                            .system(
                                size:50
                            )
                        )
                        .foregroundColor(
                            .gray
                        )
                        
                        
                        Text(
                            "No Data"
                        )
                        .foregroundColor(
                            .gray
                        )
                    }
                    .frame(
                        maxWidth:.infinity
                    )
                    
                    Spacer()
                    
                } else {
                    
                    ScrollView {
                        
                        LazyVStack(
                            spacing:15
                        ) {
                            
                            ForEach(
                                viewModel.recordings
                            ) { audio in
                                
                                VStack(
                                    spacing:12
                                ) {
                                    
                                    VStack(
                                        alignment:.leading,
                                        spacing:8
                                    ) {
                                        
                                        Text(
                                            audio.date.formatted(
                                                .dateTime
                                                    .month(.abbreviated)
                                                    .day()
                                            )
                                            +
                                            " - " +
                                            audio.date.formatted(
                                                .dateTime
                                                    .hour()
                                                    .minute()
                                            )
                                        )
                                        .font(
                                            .caption2
                                        )
                                        .foregroundColor(
                                            .gray
                                        )
                                        
                                        
                                        // Name
                                        
                                        if viewModel.editingId == audio.id {
                                            
                                            TextField(
                                                "Recording Name",
                                                text:
                                                $viewModel.editedName
                                            )
                                            .textFieldStyle(
                                                RoundedBorderTextFieldStyle()
                                            )
                                            .onSubmit {
                                                
                                                viewModel.saveEditedName(
                                                    audio
                                                )
                                            }
                                            
                                        } else {
                                            
                                            Text(
                                                audio.title
                                            )
                                            .font(
                                                .headline
                                            )
                                            .fixedSize(
                                                horizontal:false,
                                                vertical:true
                                            )
                                        }
                                        
                                        
                                        // Bottom row
                                        
                                        HStack {
                                            
                                            HStack(
                                                spacing:6
                                            ) {
                                                
                                                Image(
                                                    systemName:
                                                    "play.fill"
                                                )
                                                .font(
                                                    .caption2
                                                )
                                                
                                                Text(
                                                    String(
                                                        format:
                                                        "%02d:%02d",
                                                        Int(audio.duration)/60,
                                                        Int(audio.duration)%60
                                                    )
                                                )
                                                .font(
                                                    .caption
                                                )
                                            }
                                            .padding(
                                                .horizontal,
                                                10
                                            )
                                            .padding(
                                                .vertical,
                                                6
                                            )
                                            .background(
                                                Color.gray.opacity(
                                                    0.1
                                                )
                                            )
                                            .clipShape(
                                                Capsule()
                                            )
                                            
                                            
                                            Spacer()
                                            
                                            
                                            HStack(
                                                spacing:15
                                            ) {
                                                
                                                // Edit
                                                
                                                Button {
                                                    
                                                    if viewModel.editingId == audio.id {
                                                        
                                                        viewModel.saveEditedName(
                                                            audio
                                                        )
                                                        
                                                    } else {
                                                        
                                                        viewModel.startEditing(
                                                            audio
                                                        )
                                                    }
                                                    
                                                } label: {
                                                    
                                                    Image(
                                                        systemName:
                                                        viewModel.editingId == audio.id
                                                        ?
                                                        "checkmark"
                                                        :
                                                        "pencil"
                                                    )
                                                    .foregroundColor(
                                                        .black
                                                    )
                                                }
                                                
                                                
                                                // Share
                                                
                                                Button {
                                                    
                                                    print(
                                                        "Share tapped"
                                                    )
                                                    
                                                } label: {
                                                    
                                                    Image(
                                                        systemName:
                                                        "paperplane.fill"
                                                    )
                                                    .font(
                                                        .system(
                                                            size:18,
                                                            weight: .light
                                                        )
                                                    )
                                                    .foregroundColor(
                                                        .black
                                                    )
                                                }
                                                
                                                
                                                // Delete
                                                
                                                Button {
                                                    
                                                    viewModel.recordingToDelete =
                                                    audio
                                                    
                                                    viewModel.showDeleteAlert =
                                                    true
                                                    
                                                } label: {
                                                    
                                                    Image(
                                                        systemName:"trash"
                                                    )
                                                    .foregroundColor(.black)
                                                }
                                            }
                                        }
                                    }
                                    .padding(
                                        .horizontal,
                                        10
                                    )
                                    
                                    Divider()
                                }
                                .padding(
                                    .top,
                                    8
                                )
                                .contentShape(
                                    Rectangle()
                                )
                                .onTapGesture {
                                    
                                    viewModel.selectedRecording =
                                    audio
                                    
                                    viewModel.showSheet =
                                    true
                                    
                                    viewModel.playRecording(
                                        audio
                                    )
                                }
                            }
                        }
                        .padding(
                            .bottom,
                            100
                        )
                    }
                }
            }
            .padding()
            .blur(
                radius:
                viewModel.showSheet
                ? 3 : 0
            )
            .allowsHitTesting(
                !viewModel.showSheet
            )
            
            
            // Mic
            
            Button {
                
                viewModel.recordButtonTapped()
                
            } label: {
                
                Circle()
                    .fill(
                        .black
                    )
                    .frame(
                        width:90,
                        height:90
                    )
                    .overlay {
                        
                        Image(
                            systemName:
                            viewModel.isRecording
                            ?
                            "stop.fill"
                            :
                            "mic.fill"
                        )
                        .font(
                            .system(
                                size:35
                            )
                        )
                        .foregroundColor(
                            .white
                        )
                    }
            }
            .padding(
                .bottom,
                30
            )
            
            
            // Popup
            
            if viewModel.showSheet {
                
                RecordingSheetView(
                    
                    showSheet:
                    $viewModel.showSheet,
                    
                    isRecording:
                    viewModel.isRecording,
                    
                    isPlaying:
                    $viewModel.isPlaying,
                    
                    time:
                    viewModel.currentTime,
                    
                    progress: Binding(
                        
                        get: {
                            viewModel.progress
                        },
                        
                        set: {
                            
                            viewModel.progress =
                            $0
                            
                            viewModel.seekAudio()
                        }
                    ),
                    
                    duration:
                    viewModel.duration,
                    
                    waveform:
                    viewModel.waveform,
                    
                    playPauseAction: {
                        
                        if viewModel.isRecording {
                            
                            if viewModel.isPlaying {
                                
                                viewModel.pauseRecording()
                                
                            } else {
                                
                                viewModel.resumeRecording()
                            }
                            
                        } else {
                            
                            if viewModel.isPlaying {
                                
                                viewModel.pausePlaying()
                                
                            } else if let recording =
                                        viewModel.selectedRecording {
                                
                                viewModel.playRecording(
                                    recording
                                )
                            }
                        }
                    },
                    
                    doneAction: {
                        
                        viewModel.stopRecording()
                    },
                    
                    closeAction: {
                        
                        viewModel.stopPlaying()
                        
                        viewModel.showSheet =
                        false
                    }
                )
            }
        }
        .alert(
            viewModel.alertMessage,
            isPresented:
                $viewModel.showAlert
        ) {
            
            Button(
                "OK"
            ) {}
        }
        .alert(
            "Delete Recording",
            isPresented:
            $viewModel.showDeleteAlert
        ) {
            
            Button(
                "Delete",
                role:.destructive
            ) {
                
                if let recording =
                    viewModel.recordingToDelete {
                    
                    viewModel.deleteRecording(
                        recording
                    )
                }
            }
            
            
            Button(
                "Cancel",
                role:.cancel
            ) { }
            
        } message: {
            
            Text(
                "Are you sure you want to delete this recording? This action cannot be undone."
            )
        }
    }
}

#Preview {
    HomeView()
}
