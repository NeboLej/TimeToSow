//
//  NoteModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import SwiftData

@Model
final class NoteModel {
    @Attribute(.unique) var id: UUID
    var date: Date
    var time: Int
    var plant: PlantModel?
    @Relationship(deleteRule: .nullify, inverse: \TagModel.notes) var tag: TagModel?
    
    init(id: UUID, date: Date, time: Int, plant: PlantModel? = nil, tag: TagModel) {
        self.id = id
        self.date = date
        self.time = time
        self.plant = plant
        self.tag = tag
    }
    
    convenience init(from: Note) {
        self.init(id: from.id, date: from.date, time: from.time, tag: TagModel(from: from.tag))
    }
}

import GRDB

struct NoteModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord {
    static let databaseTableName = "note"
    
    var id: UUID
    var date: Date
    var time: Int
    
    var plantID: UUID
    var tagID: UUID
    
    var tag: TagModelGRDB?
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from: Note, plantID: UUID) {
        id = from.id
        date = from.date
        time = from.time
        self.plantID = plantID
        tagID = from.tag.id
    }
    
    enum CodingKeys: String, CodingKey {
        case id, date, time, plantID, tagID, tag
    }
}

extension NoteModelGRDB {
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["date"] = date
        container["time"] = time
        container["plantID"] = plantID
        container["tagID"] = tagID
    }
}

extension NoteModelGRDB {
    static let tag = belongsTo(TagModelGRDB.self, using: ForeignKey(["tagID"]))
}
