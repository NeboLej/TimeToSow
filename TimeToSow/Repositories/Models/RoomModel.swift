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
    var name: String = ""
    var image: String = ""
    
    var parents: [MonthRoomModel] = []
    
    init(id: UUID, name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
    
    convenience init(from: RoomType) {
        self.init(id: from.id, name: from.name, image: from.image)
    }
}
