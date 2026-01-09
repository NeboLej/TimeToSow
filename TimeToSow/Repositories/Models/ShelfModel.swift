//
//  ShelfModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import SwiftData

@Model
final class ShelfModel {
    @Attribute(.unique) var id: UUID
    var name: String = ""
    var image: String = ""
    
    var shelfPositions: [ShelfPosition] = []
    var parents: [MonthRoomModel] = []
    
    init(id: UUID, name: String, image: String, shelfPositions: [ShelfPosition] = []) {
        self.id = id
        self.name = name
        self.image = image
        self.shelfPositions = shelfPositions
    }
    
    convenience init(from: ShelfType) {
        self.init(id: from.id, name: from.name, image: from.image, shelfPositions: from.shelfPositions)
    }
    
//    init(from: ShelfType) {
//        id = from.id
//        name = from.name
//        image = from.image
//        shelfPositions = from.shelfPositions
//    }
}
