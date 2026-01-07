//
//  RecordsHistoryView.swift
//  TimeToSow
//
//  Created by Nebo on 07.01.2026.
//

import SwiftUI

struct RecordsHistoryView: View {
    
    let notes: [Note]
    
    private var groupNotesByDay: [[Note]] {
        let grouped = Dictionary(grouping: notes) { note in
            Calendar.current.startOfDay(for: note.date)
        }
        
        return grouped
            .sorted { $0.key > $1.key }
            .map { $0.value }
    }
    
    var body: some View {
        recordsHistorySection()
    }
    
    @ViewBuilder
    private func recordsHistorySection() -> some View {
        VStack {
            ForEach(groupNotesByDay, id: \.self) { dayNotes in
                VStack(alignment: .leading) {
                    Text(dayNotes.first?.date.toReadableDate() ?? "")
                        .font(.myRegular(12))
                        .foregroundStyle(.black.opacity(0.6))
                        .padding(.top, 16)
                        .padding(.leading, 10)
                    
                    ForEach(dayNotes) { note in
                        SwipeableRow {
                            recordRow(note)
                        } actions: {
                            Image(systemName: "trash")
                                .frame(width: 60, height: 46)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func recordRow(_ note: Note) -> some View {
        HStack(spacing: 10) {
            Rectangle()
                .frame(width: 10)
                .foregroundStyle(Color(hex: note.tag.color))
            Text(note.time.toHoursAndMinutes())
                .font(.myRegular(16))
                .foregroundStyle(.black)
            Spacer()
            TagView(tag: note.tag)
                .padding(.trailing, 10)
        }
        .frame(height: 46)
        .background(Color(hex: "E7E7E7"))
        .cornerRadius(20, corners: [.bottomRight, .topRight])
    }
    
}
