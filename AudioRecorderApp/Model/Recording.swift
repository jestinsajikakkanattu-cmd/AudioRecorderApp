//
//  Recording.swift
//  AudioRecorderApp
//
//  Created by Jestin Saji on 25/05/26.
//


import Foundation

struct Recording: Identifiable {
    
    let id = UUID()
    let fileURL: URL
    var title: String
    let duration: Double
    let date: Date
}
