//
//  ShelfType.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

struct ShelfType: Hashable {
    let id: UUID
    let name: String
    let image: String
    let shelfPositions: [ShelfPosition]
    
    init(id: UUID = UUID(), name: String, image: String, shelfPositions: [ShelfPosition]) {
        self.id = id
        self.name = name
        self.image = image
        self.shelfPositions = shelfPositions
    }
    
    init(from: ShelfModel) {
        id = from.id
        name = from.name
        image = from.image
        shelfPositions = from.shelfPositions
    }
}

struct ShelfPosition: Hashable, Codable {
    let coefOffsetY: CGFloat
    let paddingLeading: CGFloat
    let paddingTrailing: CGFloat
}
