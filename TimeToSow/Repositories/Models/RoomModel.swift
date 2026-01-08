//
//  RoomModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import SwiftData

@Model
final class RoomModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var image: String
    
    init(id: UUID = UUID(), name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
    
    init(from: RoomType) {
        id = from.id
        image = from.image
        name = from.name
    }
}
