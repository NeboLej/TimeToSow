//
//  MonthRoomModel.swift
//  TimeToSow
//
//  Created by Nebo on 09.01.2026.
//

import Foundation
import SwiftData

@Model
final class MonthRoomModel {
    @Attribute(.unique) var id: UUID = UUID()
    @Relationship(deleteRule: .noAction, inverse: .none) var shelfType: ShelfModel
    @Relationship(deleteRule: .noAction, inverse: .none) var roomType: RoomModel
    
    @Relationship(deleteRule: .cascade, inverse: \PlantModel.rootRoom) var plants: [PlantModel]
    
    var name: String
    var dateCreate: Date
    
    init(id: UUID, shelfType: ShelfModel, roomType: RoomModel, plants: [PlantModel], name: String, dateCreate: Date) {
        self.id = id
        self.shelfType = shelfType
        self.roomType = roomType
        self.plants = plants
        self.name = name
        self.dateCreate = dateCreate
    }
    
    init(from: UserMonthRoom) {
        id = from.id
        shelfType = ShelfModel(from: from.shelfType)
        roomType = RoomModel(from: from.roomType)
        plants = from.plants.map { PlantModel(from: $0.value) }
        name = from.name
        dateCreate = from.dateCreate
    }
}
