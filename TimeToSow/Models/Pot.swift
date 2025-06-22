//
//  Pot.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

enum PotType: Hashable, Equatable, CaseIterable {
    case small, medium, large
}

struct Pot: Hashable {
    let id: UUID = UUID.init()
    let potType: PotType
    let name: String
    let image: String
    let width: Int
    
    init(potType: PotType, name: String, image: String, width: Int) {
        self.potType = potType
        self.name = name
        self.image = image
        self.width = width
    }
}
