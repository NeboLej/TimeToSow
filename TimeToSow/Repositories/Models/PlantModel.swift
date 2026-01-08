//
//  PlantModel.swift
//  TimeToSow
//
//  Created by Nebo on 09.01.2026.
//

import Foundation
import SwiftData

@Model
final class PlantModel {
    @Attribute(.unique) var id: UUID
    @Relationship(deleteRule: .nullify, inverse: .none) var seed: SeedModel
    @Relationship(deleteRule: .nullify, inverse: .none) var pot: PotModel
    @Relationship(deleteRule: .cascade, inverse: \NoteModel.plant) var notes: [NoteModel] = []
    
    var name: String
    var userDescription: String
    var offsetY: Double
    var offsetX: Double
    var time: Int
    
    init(id: UUID, seed: SeedModel, pot: PotModel, notes: [NoteModel], name: String,
         userDescription: String, offsetY: Double, offsetX: Double, time: Int) {
        self.id = id
        self.seed = seed
        self.pot = pot
        self.notes = notes
        self.name = name
        self.userDescription = userDescription
        self.offsetY = offsetY
        self.offsetX = offsetX
        self.time = time
    }
    
    init(from: Plant) {
        id = from.id
        seed = SeedModel(from: from.seed)
        pot = PotModel(from: from.pot)
        name = from.name
        userDescription = from.description
        offsetX = from.offsetX
        offsetY = from.offsetY
        time = from.time
        notes = from.notes.map { NoteModel(from: $0) }
    }
}
