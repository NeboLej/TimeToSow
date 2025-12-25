//
//  Plant.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

struct Plant: Hashable, Identifiable {
    let id: String
    let seed: Seed
    let pot: Pot
    
    let offsetY: Double
    let offsetX: Double
    let time: Int
    
    let notes: [Note]
    
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        lhs.id == rhs.id
    }
    
    init(id: String = UUID().uuidString, seed: Seed, pot: Pot, offsetY: Double, offsetX: Double, notes: [Note]) {
        self.id = id
        self.seed = seed
        self.pot = pot
        self.offsetY = offsetY
        self.offsetX = offsetX
        self.time = notes.reduce(0) { $0 + $1.time }
        self.notes = notes
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
        Plant(id: self.id, seed: self.seed, pot: self.pot,
              offsetY: offsetY ?? self.offsetY, offsetX: offsetX ?? self.offsetX,
              notes: notes ?? self.notes)
    }
}
