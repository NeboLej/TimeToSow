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
    @Attribute(.unique) var id: UUID
    @Relationship(deleteRule: .nullify, inverse: \ShelfModel.parents) var shelfType: ShelfModel?
    @Relationship(deleteRule: .nullify, inverse: \RoomModel.parents) var roomType: RoomModel?
    
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
        plants = from.plants.map { PlantModel(from: $0.value) }.sorted(by: { $0.name < $1.name} )
        name = from.name
        dateCreate = from.dateCreate
    }
}

import GRDB

struct UserRoomModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord  {
    static let databaseTableName = "userRoom"

    var id: UUID
    var shelfID: UUID
    var roomID: UUID
    
    var name: String
    var dateCreate: Date
    
    var shelf: ShelfModelGRDB?
    var room: RoomModelGRDB?
    var plants: [PlantModelGRDB] = []
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    enum CodingKeys: CodingKey {
        case id, shelfID, roomID, name, dateCreate
        case shelf, room, plants
    }
    
    init(from1: UserMonthRoom) {
        id = from1.id
        shelfID = from1.shelfType.id
        roomID = from1.roomType.id
        name = from1.name
        dateCreate = from1.dateCreate
    }
}

extension UserRoomModelGRDB {
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["shelfID"] = shelfID
        container["roomID"] = roomID
        container["name"] = name
        container["dateCreate"] = dateCreate
    }
}

extension UserRoomModelGRDB {
    static let shelf = belongsTo(ShelfModelGRDB.self, using: ForeignKey(["shelfID"]))
    static let room = belongsTo(RoomModelGRDB.self, using: ForeignKey(["roomID"]))
    static let plants = hasMany(PlantModelGRDB.self, using: ForeignKey(["rootRoomID"]))
}
