//
//  DecorModelGRDB.swift
//  TimeToSow
//
//  Created by Nebo on 25.01.2026.
//

import Foundation
import GRDB

struct DecorModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord {
    static let databaseTableName = "decor"
    mutating func didInsert(with rowID: Int64, for column: String?) { }

    var id: UUID
    var decorTypeID: UUID
    var rootRoomID: UUID
    
    var offsetY: Double
    var offsetX: Double
    
    var decorType: DecorTypeModelGRDB?
    
    enum CodingKeys: CodingKey {
        case id, decorTypeID, rootRoomID, offsetY, offsetX
        case decorType
    }
    

//    init(from: Decor) {
//        id = from.id
//        name = from.name
//        locationType = from.locationType
//        animationOptions = from.animationOptions
//        resourceName = from.resourceName
//        positon = from.positon
//        height = from.height
//        width = from.width
//    }
}

extension DecorModelGRDB {
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["decorTypeID"] = decorTypeID
        container["offsetY"] = offsetY
        container["offsetX"] = offsetX
    }
}

extension DecorModelGRDB {
    static let decorType = belongsTo(DecorTypeModelGRDB.self, using: ForeignKey(["decorTypeID"]))

}

