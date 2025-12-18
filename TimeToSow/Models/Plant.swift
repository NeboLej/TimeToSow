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
    let tag: Tag
    
    let offsetY: Double
    let offsetX: Double
    let time: Int
    
    static func == (lhs: Plant, rhs: Plant) -> Bool {
        lhs.id == rhs.id &&
        lhs.seed == rhs.seed &&
        lhs.pot == rhs.pot &&
        lhs.tag == rhs.tag &&
        lhs.time == rhs.time
    }
    
    init(id: UUID = UUID.init(), seed: Seed, pot: Pot, tag: Tag, offsetX: Double = 40, offsetY: Double = 100, time: Int = 0) {
        self.id = id
        self.seed = seed
        self.pot = pot
        self.tag = tag
        self.offsetX = offsetX
        self.offsetY = offsetY
        self.time = time
    }
    
    func copy(offsetX: Double? = nil, offsetY: Double? = nil) -> Plant {
        Plant(id: self.id, seed: self.seed, pot: self.pot, tag: self.tag, offsetX: offsetX ?? self.offsetX, offsetY: offsetY ?? self.offsetY, time: self.time)
    }
}
