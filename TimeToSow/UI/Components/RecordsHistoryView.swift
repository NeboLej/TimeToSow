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
                        
                        recordRow(note)
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button("Delete", systemImage: "trash") {
                                    print("delete")
                                }.tint(.strokeAcsent2)
                            }
                            .enableScrollViewSwipeActionModifier()
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
        .frame(height: 50)
        .background(Color(hex: "E7E7E7"))
        .cornerRadius(20, corners: [.bottomRight, .topRight])
    }
}

#Preview {
    PlantDetailScreen(plant: Plant(rootRoomID: UUID(),
                                   seed: Seed(name: "seed1.name",
                                              image: "seed23",
                                              height: 45,
                                              rarity: .common),
                                   pot: Pot(name: "pot1.name",
                                            image: "pot21",
                                            height: 24,
                                            rarity: .common),
                                   name: "Oleg",
                                   description: "jasdkjn aksnd ajsdnkan kjndknakj dna",
                                   offsetY: 200,
                                   offsetX: 200,
                                   notes: [
                                    Note(date: Date().getOffsetDate(offset: -3), time: 100, tag: Tag(name: "Name", color: "#3D90D9")),
                                    Note(date: Date(), time: 70, tag: Tag(name: "Name2", color: "#13D0D9"))
                                   ]
                                  ))
}
