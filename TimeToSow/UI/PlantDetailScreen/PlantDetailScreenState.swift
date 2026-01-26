//
//  PlantDetailScreenState.swift
//  TimeToSow
//
//  Created by Nebo on 26.01.2026.
//

import Foundation

struct PlantDetailScreenState {
    
    let plant: Plant
//    let groupNotesByDay: [[Note]]
    
    init(plant: Plant) {
        self.plant = plant
//        
//        let grouped = Dictionary(grouping: plant.notes) { note in
//            Calendar.current.startOfDay(for: note.date)
//        }
//        self.groupNotesByDay = grouped.sorted { $0.key > $1.key }.map { $0.value }
    }
}
