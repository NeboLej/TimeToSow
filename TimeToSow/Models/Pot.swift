//
//  Pot.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

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
