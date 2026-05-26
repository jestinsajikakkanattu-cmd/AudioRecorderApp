Audio Recorder App

Description:
A simple audio recording application built using SwiftUI and MVVM architecture. The app allows users to record audio with live waveform visualization, save recordings locally, manage recordings, and play them back with playback controls.

Features:

• Record audio using microphone
• Live animated waveform while recording
• Pause and resume recording
• Save recordings locally
• Display recordings list
• Rename recordings
• Delete recordings
• Duplicate name validation
• Audio playback
• Play / Pause support
• Seek using slider
• Display recording duration
• Display recording date and time
• Bottom sheet style player
• Background recording supported

Architecture:

MVVM (Model - View - ViewModel)

Project Structure:

Model
- Recording.swift

View
- HomeView.swift
- RecordingSheetView.swift
- SmoothWaveView.swift
- WaveformView.swift

ViewModel
- AudioRecorderViewModel.swift

Supporting Classes
- AudioRecorderManager.swift
- AudioPlayerManager.swift

Responsibilities:

View:
- UI rendering
- Display recordings list
- Display waveform and playback UI

ViewModel:
- Business logic
- Recording state management
- Playback state management
- Rename/Delete handling

Supporting Classes:
- Audio recording operations
- Audio playback operations
- AVFoundation handling

Tech Stack:

- SwiftUI
- MVVM
- AVFoundation
- AVAudioRecorder
- AVAudioPlayer
- Observation

Implemented Functionalities:

Recording:
- Start recording
- Pause recording
- Resume recording
- Stop recording
- Save recording

Recording Management:
- Load recordings
- Rename recordings
- Delete recordings
- Duplicate name validation

Playback:
- Play audio
- Pause audio
- Resume from previous position
- Seek audio
- Stop playback

Unit Testing:
Basic XCTest cases added for:
- Rename functionality
- Delete functionality
- Play/Pause state validation

Future Improvements: can be do later
- Search functionality
- Categories/Folders
- Share recording option
- Background recording
- Better waveform customization

Built using SwiftUI with focus on clean code, reusable components and user-friendly experience.
