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
    @Relationship(deleteRule: .nullify, inverse: \SeedModel.plants) var seed: SeedModel?
    @Relationship(deleteRule: .nullify, inverse: \PotModel.plants) var pot: PotModel?
    @Relationship(deleteRule: .cascade, inverse: \NoteModel.plant) var notes: [NoteModel]
    
    var name: String
    var userDescription: String
    var offsetY: Double
    var offsetX: Double
    var time: Int
    var rootRoom: MonthRoomModel?
    
    init(id: UUID, seed: SeedModel?, pot: PotModel?, notes: [NoteModel], name: String,
         userDescription: String, offsetY: Double, offsetX: Double, time: Int, rootRoom: MonthRoomModel? = nil) {
        self.id = id
        self.seed = seed
        self.pot = pot
        self.notes = notes
        self.name = name
        self.userDescription = userDescription
        self.offsetY = offsetY
        self.offsetX = offsetX
        self.time = time
        self.rootRoom = rootRoom
    }
    
    convenience init(from: Plant) {
        self.init(id: from.id,
                  seed: SeedModel(from: from.seed),
                  pot: PotModel(from: from.pot),
                  notes: from.notes.map { NoteModel(from: $0) },
                  name: from.name,
                  userDescription: from.description,
                  offsetY: from.offsetY,
                  offsetX: from.offsetX,
                  time: from.time)
    }
}
