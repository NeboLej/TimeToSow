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
                let startPoint = (startAngle + gap / 2) / 360
                let endPoint = (endAngle - gap / 2) / 360
                
                Circle().inset(by: lineWidth / 2)
                    .trim(from: startPoint,to: endPoint)
                    .stroke(note.color, style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .butt)
                    )
                
                Image(.smallTexture1)
                    .resizable()
                    .clipShape(
                        .circle.inset(by: lineWidth / 2)
                        .trim(from: startPoint, to: endPoint)
                        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt))
                    )
                    .blendMode(.multiply)
            }
            .rotationEffect(.degrees(-90))
        }
        .rotationEffect(.degrees(-10))
    }
    
    
    func getAngle(id: Int) -> Double {
        let value = notes.prefix(id).reduce(0) { $0 + $1.value }
        let angle = 360.0 * value / fullValue
        return angle
    }
}

#Preview {
    
    
    let tag1 = Tag(name: "Yoga", color: "236cfe")
    let tag2 = Tag(name: "Jogffrf", color: "0fd")
    let tag3 = Tag(name: "NewGGG", color: "fff453")
    let tag4 = Tag(name: "tag4", color: "453")
    let tag5 = Tag(name: "tag5", color: "fffeee")
    let tag6 = Tag(name: "tag6", color: "eee343")
    let tag7 = Tag(name: "tag7", color: "fed321")
    
    let values = [
        Note(date: Date(), time: 30, tag: tag1),
        Note(date: Date(), time: 310, tag: tag2),
        Note(date: Date(), time: 230, tag: tag1),
        Note(date: Date(), time: 20, tag: tag3),
        Note(date: Date(), time: 120, tag: tag4),
        //        Note(date: Date(), time: 12, tag: tag5),
        //        Note(date: Date(), time: 80, tag: tag6),
        //        Note(date: Date(), time: 43, tag: tag7),
    ].map { PieData(value: Double($0.time), color: Color(hex: $0.tag.color)) }
    
    PieChartView(notes: values, lineWidth: 50)
        .frame(width: 300, height: 300)
}
