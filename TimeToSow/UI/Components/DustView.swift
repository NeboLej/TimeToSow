//
//  DustView.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import SwiftUI

struct DustView: View {
    @State var width: CGFloat
    
    @State private var offsetCircle1: CGPoint = .zero
    @State private var offsetCircle2: CGPoint = .zero
    @State private var offsetCircle3: CGPoint = .zero
    @State private var offsetCircle4: CGPoint = .zero
    @State private var opacity: Double = 1
    
    
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .fill(Color.gray.opacity(opacity))
                .frame(width: width/5, height: width/4)
                .offset(x: offsetCircle1.x, y: offsetCircle1.y)
            Circle()
                .fill(Color.gray.opacity(opacity))
                .frame(width: width/6, height: width/4)
                .offset(x: offsetCircle2.x, y: offsetCircle2.y)
            Circle()
                .fill(Color.gray.opacity(opacity))
                .frame(width: width/6, height: width/4)
                .offset(x: offsetCircle3.x, y: offsetCircle3.y)
            Circle()
                .fill(Color.gray.opacity(opacity))
                .frame(width: width/5, height: width/4)
                .offset(x: offsetCircle4.x, y: offsetCircle4.y)
            Circle()
                .fill(Color.gray.opacity(opacity))
                .frame(width: width/6, height: width/4)
                .offset(x: offsetCircle4.x, y: offsetCircle4.y)
            Circle()
                .fill(Color.gray.opacity(opacity))
                .frame(width: width/5, height: width/4)
                .offset(x: offsetCircle3.x, y: offsetCircle3.y)
        }
        .offset(y: -width/5)
        .onAppear {
            withAnimation {
                offsetCircle1 = CGPoint(x: (-15...0).randomElement()!, y: -(5...15).randomElement()!)
                offsetCircle2 = CGPoint(x: (-15...0).randomElement()!, y: -(5...15).randomElement()!)
                offsetCircle3 = CGPoint(x: (-0...15).randomElement()!, y: -(5...15).randomElement()!)
                offsetCircle4 = CGPoint(x: (-0...15).randomElement()!, y: -(5...15).randomElement()!)
                opacity = 0
            }
        }
    }
}

#Preview {
    DustView(width: 200)
}
