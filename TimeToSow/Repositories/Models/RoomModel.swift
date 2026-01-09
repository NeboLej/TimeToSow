//
//  RoomModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import SwiftData

@Model
final class RoomModel: RoomProtocol {
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


import GRDB

struct RoomModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord, RoomProtocol {
    static let databaseTableName = "room"
    
    var id: UUID
    var name: String
    var image: String
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from: RoomType) {
        id = from.id
        name = from.name
        image = from.image
    }
}
