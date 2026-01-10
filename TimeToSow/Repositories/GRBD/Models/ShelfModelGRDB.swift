//
//  ShelfModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import GRDB

struct ShelfModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord, ShelfProtocol {
    static let databaseTableName = "shelf"
    
    var id: UUID
    var name: String
    var image: String
    var shelfPositions: [ShelfPosition]
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from: ShelfType) {
        id = from.id
        name = from.name
        image = from.image
        shelfPositions = from.shelfPositions
    }
}
