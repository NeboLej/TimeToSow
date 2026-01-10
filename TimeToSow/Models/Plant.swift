//
//  Plant.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

struct Plant: Hashable, Identifiable {
    let id: UUID
    let seed: Seed
    let pot: Pot
    
    let name: String
    let description: String
    let offsetY: Double
    let offsetX: Double
    let time: Int
    
    let notes: [Note]
    let rootRoomID: UUID
    
    init(from: PlantModelGRDB) {
        guard let seedDB = from.seed, let potDB = from.pot else {
            fatalError("Failed to create Plant from PlantModelGRDB: missing seed or pot")
        }
        id = from.id
        seed = Seed(from: seedDB)
        pot = Pot(from: potDB)
        name = from.name
        description = from.userDescription
        offsetX = from.offsetX
        offsetY = from.offsetY
        notes = from.notes.map { Note(from: $0) }
        time = notes.reduce(0) { $0 + $1.time }
        rootRoomID = from.rootRoomID
    }
    
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: UUID = UUID(), rootRoomID: UUID, seed: Seed, pot: Pot, name: String, description: String,
         offsetY: Double, offsetX: Double, notes: [Note]) {
        self.id = id
        self.seed = seed
        self.pot = pot
        self.name = name
        self.description = description
        self.offsetY = offsetY
        self.offsetX = offsetX
        self.time = notes.reduce(0) { $0 + $1.time }
        self.notes = notes
        self.rootRoomID = rootRoomID
    }
    
    func copy(offsetX: Double? = nil, offsetY: Double? = nil, notes: [Note]? = nil) -> Plant {
        Plant(id: self.id, rootRoomID: self.rootRoomID, seed: self.seed, pot: self.pot, name: self.name, description: self.description,
              offsetY: offsetY ?? self.offsetY, offsetX: offsetX ?? self.offsetX,
              notes: notes ?? self.notes)
    }
}
