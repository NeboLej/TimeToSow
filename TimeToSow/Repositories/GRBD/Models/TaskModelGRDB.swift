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
    var rewardPlantID: UUID?
    
    var tag: TagModelGRDB?
    var plant: PlantModelGRDB?
    var rewardPlant: PlantModelGRDB?
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    enum CodingKeys: CodingKey {
        case id, startTime, time, tagID, plantID
        case tag, plant, rewardPlant
    }
    
    init(from: TaskModel) {
        id = from.id
        startTime = from.startTime
        time = from.time
        tagID = from.tagID
        plantID = from.plantID
        rewardPlantID = from.rewardPlantID
    }
}

extension TaskModelGRDB {
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["startTime"] = startTime
        container["time"] = time
        container["tagID"] = tagID
        container["plantID"] = plantID
        container["rewardPlantID"] = rewardPlantID
    }
}

extension TaskModelGRDB {
    static let tag = belongsTo(TagModelGRDB.self, using: ForeignKey(["tagID"]))
    static let plant = belongsTo(PlantModelGRDB.self, using: ForeignKey(["plantID"])).forKey("plant")
    static let rewardPlant = belongsTo(PlantModelGRDB.self, using: ForeignKey(["rewardPlantID"])).forKey("rewardPlant")
}
