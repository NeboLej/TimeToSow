//
//  Shelf.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

struct ShelfType {
    let name: String
    let image: String
    let shelfPositions: [ShelfPosition]
}

struct ShelfPosition: Hashable {
    let coefOffsetY: CGFloat
    let paddingLeading: CGFloat
    let paddingTrailing: CGFloat
}

class Shelf {
    let id: UUID = UUID.init()
    let type: ShelfType
    let name: String
    let dateCreate: Date
    let plants: [Plant]
    
    init(type: ShelfType, name: String, dateCreate: Date, plants: [Plant]) {
        self.type = type
        self.name = name
        self.dateCreate = dateCreate
        self.plants = plants
    }
}
