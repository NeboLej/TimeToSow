//
//  RoomModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
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
