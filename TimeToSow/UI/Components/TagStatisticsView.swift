//
//  TagStatisticsView.swift
//  TimeToSow
//
//  Created by Nebo on 25.12.2025.
//

import Foundation
import SwiftUI

struct TagStatisticsView: View {
    
    var notes: [Note]
    var maxTagsCount: Int = 4
    @State private var isShowAllTags: Bool = false
    
    private var unicalNotes: [Note] {
        let dict = notes.reduce(into: [:]) { result, note in
            result[note.tag, default: 0] += note.time
        }
        let sortedTags = dict.map { Note(date: Date(), time: $0.value, tag: $0.key) }.sorted { $0.time > $1.time }
        
        if sortedTags.count <= maxTagsCount {
            return sortedTags
        } else {
            if isShowAllTags {
                return sortedTags
            } else {
                var namedTags = Array(sortedTags.prefix(maxTagsCount-1))
                let remaining = Array(sortedTags.dropFirst(maxTagsCount-1))
                let othetTagTime = remaining.reduce(0) { $0 + $1.time }
                namedTags.append(Note(date: Date(), time: othetTagTime, tag: Tag(name: "Other", color: "#808080")))
                return namedTags
            }
        }
    }
    
    private var fullTime: Int {
        notes.reduce(0) { $0 + $1.time }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text("Tags info")
                    .font(.myTitle(28))
                    .foregroundStyle(.black)
                tagsTable()
            }
            if unicalNotes.count > 1 {
                PieChartView(notes: unicalNotes.map { PieData(value: Double($0.time),
                                                              color: Color(hex: $0.tag.color))} )
                    .frame(width: 110, height: 110)
                    .padding(.leading, 20)
                    .padding(.top, 16)
            }
        }
        .padding(14)
        .onTapGesture {
            withAnimation {
                isShowAllTags.toggle()
            }
        }
    }
    
    @ViewBuilder
    private func tagsTable() -> some View {
        VStack(alignment: .leading) {
            ForEach(unicalNotes) { note in
                HStack {
                    TagView(tag: note.tag)
                    Spacer()
                    Text(note.time.percentBy(fullTime))
                        .font(.myRegular(14))
                        .foregroundStyle(.black)
                        .padding(.trailing, 6)
                    Text(note.time.toHoursAndMinutes())
                        .font(.myRegular(14))
                        .foregroundStyle(.black)
                }
            }
        }
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
    
    TagStatisticsView(notes: [
        Note(date: Date(), time: 30, tag: tag1),
        Note(date: Date(), time: 310, tag: tag2),
        Note(date: Date(), time: 230, tag: tag1),
        Note(date: Date(), time: 20, tag: tag3),
        Note(date: Date(), time: 120, tag: tag4),
        Note(date: Date(), time: 12, tag: tag5),
        Note(date: Date(), time: 80, tag: tag6),
        Note(date: Date(), time: 43, tag: tag7),
    ])
}
