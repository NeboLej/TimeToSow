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
    
    let description: String
    let offsetY: Double
    let offsetX: Double
    let time: Int
    let isOnShelf: Bool
    let dateCreate: Date
    
    let notes: [Note]
    let rootRoomID: UUID
    
    init(from: PlantModelGRDB) {
        guard let seedDB = from.seed, let potDB = from.pot else {
            fatalError("Failed to create Plant from PlantModelGRDB: missing seed or pot")
        }
        id = from.id
        seed = Seed(from: seedDB)
        pot = Pot(from: potDB)
        description = from.userDescription
        offsetX = from.offsetX
        offsetY = from.offsetY
        notes = from.notes.map { Note(from: $0) }
        time = notes.reduce(0) { $0 + $1.time }
        rootRoomID = from.rootRoomID
        isOnShelf = from.isOnShelf
        dateCreate = from.dateCreate
    }
    
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: UUID = UUID(), rootRoomID: UUID, seed: Seed, pot: Pot, description: String,
         offsetY: Double, offsetX: Double, isOnShelf: Bool, dateCreate: Date = Date(), notes: [Note]) {
        self.id = id
        self.seed = seed
        self.pot = pot
        self.description = description
        self.offsetY = offsetY
        self.offsetX = offsetX
        self.time = notes.reduce(0) { $0 + $1.time }
        self.notes = notes
        self.isOnShelf = isOnShelf
        self.rootRoomID = rootRoomID
        self.dateCreate = dateCreate
    }
    
    func copy(offsetX: Double? = nil, offsetY: Double? = nil, isVisible: Bool? = nil, notes: [Note]? = nil, seed: Seed? = nil, pot: Pot? = nil) -> Plant {
        Plant(id: self.id, rootRoomID: self.rootRoomID, seed: seed ?? self.seed, pot: pot ?? self.pot, description: self.description,
              offsetY: offsetY ?? self.offsetY, offsetX: offsetX ?? self.offsetX, isOnShelf: isVisible ?? self.isOnShelf, dateCreate: self.dateCreate,
              notes: notes ?? self.notes)
    }
}
