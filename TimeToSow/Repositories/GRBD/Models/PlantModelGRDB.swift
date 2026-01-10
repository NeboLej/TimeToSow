//
//  PlantModel.swift
//  TimeToSow
//
//  Created by Nebo on 09.01.2026.
//

import Foundation
import GRDB

struct PlantModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord {
    static let databaseTableName = "plant"
    
    var id: UUID
    
    var seedID: UUID
    var potID: UUID
    var rootRoomID: UUID
    
    var name: String
    var userDescription: String
    var offsetY: Double
    var offsetX: Double
    var time: Int
    
    var seed: SeedModelGRDB?
    var pot: PotModelGRDB?
    var notes: [NoteModelGRDB] = []
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from1: Plant) {
        id = from1.id
        seedID = from1.seed.id
        potID = from1.pot.id
        rootRoomID = from1.rootRoomID
        name = from1.name
        userDescription = from1.description
        offsetY = from1.offsetY
        offsetX = from1.offsetX
        time = from1.time
    }
    
    enum CodingKeys: String, CodingKey {
        case id, seedID, potID, name, userDescription, offsetY, offsetX, time, rootRoomID
        case seed, pot, notes
    }
}

extension PlantModelGRDB {
    func encode(to container: inout PersistenceContainer) {
        container["id"] = id
        container["seedID"] = seedID
        container["potID"] = potID
        container["name"] = name
        container["userDescription"] = userDescription
        container["offsetY"] = offsetY
        container["offsetX"] = offsetX
        container["time"] = time
        container["rootRoomID"] = rootRoomID
    }
}

extension PlantModelGRDB {
    static let seed = belongsTo(SeedModelGRDB.self, using: ForeignKey(["seedID"]))
    static let pot = belongsTo(PotModelGRDB.self, using: ForeignKey(["potID"]))
    static let notes = hasMany(NoteModelGRDB.self, using: ForeignKey(["plantID"]))
}
