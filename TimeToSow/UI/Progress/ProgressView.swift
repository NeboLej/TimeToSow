//
//  ProgressView.swift
//  TimeToSow
//
//  Created by Nebo on 23.08.2025.
//

import Foundation

import SwiftUI

struct CircleProgressView: View {
    let progress: Float
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(
                    Color.white,
                    lineWidth: 10
                )
                .shadow(color: .gray.opacity(0.4), radius: 0, x: 0, y: 4)
                
            Circle()
                .trim(from: 0, to: Double(progress))
                .stroke(
                     Color.strokeAcsent1,
                     style: StrokeStyle(
                         lineWidth: 10,
                         lineCap: .round
                     ))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)
            Image("timerArrow")
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom, content: {
                    Circle()
                        .fill(Color.white)
                        .frame(height: 20)
                        .offset(y: 10)
                })
                .frame(height: 70)
                .rotationEffect(.init(degrees: Double(progress) * 360), anchor: .bottom)
                .offset(y: -35)
                .shadow(color: .gray.opacity(0.4), radius: 0, x: 0, y: 4)
                .animation(.linear(duration: 1), value: progress)

                
        }
        .frame(width: 130, height: 130)

    }
    
}

#Preview {
    CircleProgressView(progress: 0.7)
}
