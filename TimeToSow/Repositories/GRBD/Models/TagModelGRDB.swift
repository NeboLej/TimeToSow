//
//  TagModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import GRDB

struct TagModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord, TagProtocol {
    static let databaseTableName = "tag"
    
    var id: UUID
    var stableId: String
    var name: String
    var color: String
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from: Tag) {
        id = from.id
        stableId = from.stableId
        name = from.name
        color = from.color
    }
}
