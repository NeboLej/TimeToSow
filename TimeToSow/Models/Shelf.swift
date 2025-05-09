//
//  Shelf.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

class ShelfType {
    var name: String = ""
}

class Shelf {
    var id: UUID = UUID.init()
    var type: ShelfType = ShelfType()
    var name: String = ""
    var dateCreate: Date = Date()
    var plants: [Plant] = []
}

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

enum PotType {
    case small, medium, large
}

class Pot {
    var id: UUID = UUID.init()
    var potType: PotType
    var name: String = ""
    var image: String = ""
    var width: Int
    
    init(potType: PotType, name: String, image: String, width: Int) {
        self.potType = potType
        self.name = name
        self.image = image
        self.width = width
    }
}

class Seed {
    var id: UUID = UUID.init()
    var name: String = ""
    var availavlePotTypes: [PotType] = []
    var image: String = ""
    var width: Int
    var startTimeInterval: Int
    var endTimeInterval: Int
    
    init(name: String, availavlePotTypes: [PotType], image: String, width: Int, startTimeInterval: Int, endTimeInterval: Int) {
        self.name = name
        self.availavlePotTypes = availavlePotTypes
        self.image = image
        self.width = width
        self.startTimeInterval = startTimeInterval
        self.endTimeInterval = endTimeInterval
    }
}

class Tag {
    var id: UUID = UUID.init()
    var name: String
    var color: String
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
}
