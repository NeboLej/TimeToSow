//
//  MonthRoomModel.swift
//  TimeToSow
//
//  Created by Nebo on 09.01.2026.
//

import Foundation
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
    var plants: [PlantModelGRDB]?
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    enum CodingKeys: CodingKey {
        case id, shelfID, roomID, name, dateCreate
        case shelf, room, plants
    }
    
    init(from: UserRoom) {
        id = from.id
        shelfID = from.shelfType.id
        roomID = from.roomType.id
        name = from.name
        dateCreate = from.dateCreate
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
