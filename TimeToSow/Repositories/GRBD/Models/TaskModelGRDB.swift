//
//  TaskModelGRDB.swift
//  TimeToSow
//
//  Created by Nebo on 05.02.2026.
//

import Foundation
import GRDB

struct TaskModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord  {
    static let databaseTableName = "task"
    
    var id: UUID
    var startTime: Date
    var time: Int
    var tagID: UUID
    var plantID: UUID?
    
    var tag: TagModelGRDB?
    var plant: PlantModelGRDB?
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from: TaskModel) {
        id = from.id
        startTime = from.startTime
        time = from.time
        tagID = from.id
        plantID = from.plantID
    }
}

extension TaskModelGRDB {
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["startTime"] = startTime
        container["time"] = time
        container["tagID"] = tagID
        container["plantID"] = plantID
    }
}

extension TaskModelGRDB {
    static let tag = belongsTo(TagModelGRDB.self, using: ForeignKey(["tagID"]))
    static let plant = belongsTo(PlantModelGRDB.self, using: ForeignKey(["plantID"]))
}
