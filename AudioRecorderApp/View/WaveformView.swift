//
//  WaveformView.swift
//  AudioRecorderApp
//
//  Created by Jestin Saji on 25/05/26.
//


import SwiftUI

struct WaveformView: View {
    
    var samples:[CGFloat]
    
    var body: some View {
        
        Canvas { context,size in
            
            var path = Path()
            
            let width = size.width /
            CGFloat(max(samples.count,1))
            
            let centerY = size.height/2
            
            path.move(
                to: CGPoint(
                    x: 0,
                    y: centerY
                )
            )
            
            for index in samples.indices {
                
                let x = CGFloat(index) * width
                
                let y = centerY -
                (samples[index] * 10)
                
                path.addQuadCurve(
                    to: CGPoint(x:x,y:y),
                    control: CGPoint(
                        x:x-(width/2),
                        y:centerY
                    )
                )
            }
            
            context.stroke(
                path,
                with:.color(.blue),
                lineWidth:3
            )
        }
        .frame(height:20)
    }
}
