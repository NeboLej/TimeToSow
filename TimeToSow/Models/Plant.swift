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
    
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: UUID = UUID(), seed: Seed, pot: Pot, name: String, description: String,
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
    }
    
    init(from: PlantModel) {
        id = from.id
        seed = Seed(from: from.seed!)
        pot = Pot(from: from.pot!)
        name = from.name
        description = from.userDescription
        offsetX = from.offsetX
        offsetY = from.offsetY
        notes = from.notes.map { Note(from: $0) }
        time = notes.reduce(0) { $0 + $1.time }
    }
    
//    init(id: UUID = UUID.init(), seed: Seed, pot: Pot, tag: Tag, offsetX: Double = 40, offsetY: Double = 100, time: Int = 0, notes: [Note] = []) {
//        self.id = id
//        self.seed = seed
//        self.pot = pot
//        self.tag = tag
//        self.offsetX = offsetX
//        self.offsetY = offsetY
//        self.time = time
//        self.notes = notes
//    }
    
    func copy(offsetX: Double? = nil, offsetY: Double? = nil, notes: [Note]? = nil) -> Plant {
        Plant(id: self.id, seed: self.seed, pot: self.pot, name: self.name, description: self.description,
              offsetY: offsetY ?? self.offsetY, offsetX: offsetX ?? self.offsetX,
              notes: notes ?? self.notes)
    }
}
