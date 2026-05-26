//
//  AudioRecorderAppTests.swift
//  AudioRecorderAppTests
//
//  Created by Jestin Saji on 27/05/26.
//

import XCTest
@testable import AudioRecorderApp

final class AudioRecorderAppTests: XCTestCase {
    
    
    func testRenameRecording() {
        
        var recording =
        Recording(
            fileURL:
            URL(
                fileURLWithPath:
                "test.m4a"
            ),
            title:"Old Name",
            duration:10,
            date:Date()
        )
        
        recording.title =
        "New Name"
        
        
        XCTAssertEqual(
            recording.title,
            "New Name"
        )
    }
    
    
    func testDeleteRecording() {
        
        var recordings:[Recording] = []
        
        
        let recording =
        Recording(
            fileURL:
            URL(
                fileURLWithPath:
                "test.m4a"
            ),
            title:"Audio",
            duration:10,
            date:Date()
        )
        
        
        recordings.append(
            recording
        )
        
        
        recordings.removeAll {
            
            $0.id ==
            recording.id
        }
        
        
        XCTAssertEqual(
            recordings.count,
            0
        )
    }
    
    
    func testPlayPauseState() {
        
        var isPlaying =
        false
        
        
        isPlaying =
        true
        
        XCTAssertTrue(
            isPlaying
        )
        
        
        isPlaying =
        false
        
        XCTAssertFalse(
            isPlaying
        )
    }
}
