//
//  RoomRepository.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation
import GRDB

protocol RoomRepositoryProtocol {
    func getRandomRoom() async -> RoomType
    func getAllRooms() async throws -> [RoomType]
}

final class RoomRepository: BaseRepository, RoomRepositoryProtocol {
    
    override func setDefaultValues() async {
        do {
            let existing = Set(try await dbPool.read {
                try String.fetchAll($0, sql: "SELECT stableId FROM room")
            })
            
            let toInsert = DefaultModels.rooms.filter { !existing.contains($0.stableId) }
            if toInsert.isEmpty { return }
            
            let count = try await dbPool.read { db in
                try RoomModelGRDB.fetchCount(db)
            }
            try await dbPool.write { db in
                for item in toInsert {
                    if try RoomModelGRDB.filter(key: item.id).fetchCount(db) == 0 {
                        var room = RoomModelGRDB(from: item)
                        try room.insert(db)
                    } else {
                        Logger.log("save new room error, not uniqe", location: .GRDB, event: .error(nil))
                    }
                }
            }
            Logger.log("default \(toInsert.count) Rooms added", location: .GRDB, event: .success)
        } catch {
            Logger.log("Failed to set default rooms", location: .GRDB, event: .error(error))
        }
    }
    
    func getAllRooms() async throws -> [RoomType] {
        try await dbPool.read { db in
            let rooms = try RoomModelGRDB.fetchAll(db).map { RoomType(from: $0) }
            Logger.log("get \(rooms.count) Rooms", location: .GRDB, event: .success)
            return rooms
        }
    }
    
    func getRandomRoom() async -> RoomType {
        do {
            let models = try await getAllRooms()
            guard let randomModel = models.randomElement() else {
                throw NSError(domain: "RoomRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "No room available"])
            }
            Logger.log("get random room", location: .GRDB, event: .success)
            return randomModel
        } catch {
            Logger.log("Failed to get random Room", location: .GRDB, event: .error(error))
            fatalError()
        }
    }
    
}
