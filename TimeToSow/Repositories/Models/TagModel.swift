//
//  TagModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import SwiftData

@Model
final class TagModel: TagProtocol {
    @Attribute(.unique) var id: UUID
    var name: String = ""
    var color: String = ""
    
    var notes: [NoteModel] = []
    
    init(id: UUID, name: String, color: String ) {
        self.id = id
        self.name = name
        self.color = color
    }
    
    convenience init(from: Tag) {
        self.init(id: from.id, name: from.name, color: from.color)
    }
}

import GRDB

struct TagModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord, TagProtocol {
    static let databaseTableName = "tag"
    
    var id: UUID
    var name: String
    var color: String
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from: Tag) {
        id = from.id
        name = from.name
        color = from.color
    }
}
