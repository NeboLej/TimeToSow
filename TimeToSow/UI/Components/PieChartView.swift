//
//  PieChartView.swift
//  TimeToSow
//
//  Created by Nebo on 26.12.2025.
//

import SwiftUI

struct PieData {
    let value: Double
    let color: Color
}

struct PieChartView: View {
    var notes: [PieData]
    var lineWidth: Double = 25
    private var fullValue: Double { notes.reduce(0) {  $0 + $1.value } }
    let gap: Double = 5
    
    var body: some View {
        ZStack {
            ForEach(Array(notes.enumerated()), id: \.offset) { index, note in
                let startAngle = getAngle(id: index)
                let endAngle = startAngle + 360.0 * note.value / fullValue
                
                Circle()
                    .trim(
                        from: (startAngle + gap / 2) / 360,
                        to: (endAngle - gap / 2) / 360
                    )
                    .stroke(
                        note.color,
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .butt
                        )
                    )
                    .rotationEffect(.degrees(-90))
            }
        }
        .rotationEffect(.degrees(-10))
        .padding(lineWidth / 2)
    }
    
    func getAngle(id: Int) -> Double {
        let value = notes.prefix(id).reduce(0) { $0 + $1.value }
        let angle = 360.0 * value / fullValue
        return angle
    }
}
