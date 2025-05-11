//
//  Plant.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

struct Plant: Hashable {
    let id: UUID = UUID.init()
    let seed: Seed
    let pot: Pot
    let tag: Tag
    
    let line: Int
    let offsetX: Double = 0
    let time: Int = 0
    
    
    init(seed: Seed, pot: Pot, tag: Tag, line: Int = 0) {
        self.seed = seed
        self.pot = pot
        self.tag = tag
        self.line = line
    }
}
