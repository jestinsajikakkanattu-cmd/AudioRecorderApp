//
//  SmoothWaveView.swift
//  AudioRecorderApp
//
//  Created by Jestin Saji on 25/05/26.
//


import SwiftUI

struct SmoothWaveView: View {
    
    var samples:[CGFloat]
    
    @State private var offset:CGFloat = 0
    
    var body: some View {
        
        TimelineView(.animation) { _ in
            
            Canvas { context,size in
                
                var path = Path()
                
                let width = size.width
                let height = size.height
                
                let baseY = height * 0.65
                
                path.move(
                    to: CGPoint(
                        x:0,
                        y:baseY
                    )
                )
                
                
                for x in stride(
                    from:0,
                    through:width,
                    by:2
                ) {
                    
                    let progress = x / width
                    
                    let sampleIndex =
                    Int(
                        progress *
                        CGFloat(
                            max(
                                samples.count-1,
                                0
                            )
                        )
                    )
                    
                    let amplitude =
                    samples.isEmpty
                    ?
                    3
                    :
                    samples[sampleIndex] * 12
                    
                    
                    let wave =
                    sin(
                        (progress * 6 * .pi)
                        + offset
                    )
                    
                    let y =
                    baseY -
                    (wave * amplitude)
                    
                    
                    path.addLine(
                        to: CGPoint(
                            x:x,
                            y:y
                        )
                    )
                }
                
                
                // Fill bottom
                
                path.addLine(
                    to: CGPoint(
                        x:width,
                        y:height
                    )
                )
                
                path.addLine(
                    to: CGPoint(
                        x:0,
                        y:height
                    )
                )
                
                path.closeSubpath()
                
                
                context.fill(
                    path,
                    with: .color(
                        Color.blue.opacity(0.35)
                    )
                )
            }
        }
        .clipShape(
            RoundedRectangle(
                cornerRadius:35
            )
        )
        .onAppear {
            
            withAnimation(
                .linear(
                    duration:0.8
                )
                .repeatForever(
                    autoreverses:false
                )
            ) {
                
                offset = .pi * 2
            }
        }
    }
}
