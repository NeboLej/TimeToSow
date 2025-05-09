//
//  Plant.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

class Plant {
    var id: UUID = UUID.init()
    var seed: Seed
    var pot: Pot
    var tag: Tag
    
    var time: Int = 0
    var line: Int = 0
    var offsetX: Double = 0
    
    
    init(seed: Seed, pot: Pot, tag: Tag) {
        self.seed = seed
        self.pot = pot
        self.tag = tag
    }
}
