//
//  NoteModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import SwiftData

@Model
final class NoteModel {
    @Attribute(.unique) var id: UUID
    var date: Date
    var time: Int
    var plant: PlantModel?
    @Relationship(deleteRule: .nullify, inverse: .none) var tag: TagModel
    
    init(id: UUID, date: Date, time: Int, plant: PlantModel? = nil, tag: TagModel) {
        self.id = id
        self.date = date
        self.time = time
        self.plant = plant
        self.tag = tag
    }
    
    init(from: Note) {
        id = from.id
        date = from.date
        time = from.time
        tag = TagModel(from: from.tag)
    }
}
