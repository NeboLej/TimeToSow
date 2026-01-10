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
            let count = try await dbPool.read { db in
                try RoomModelGRDB.fetchCount(db)
            }
            
            if count == 0 {
                try await dbPool.write { db in
                    for defaultModel in DefaultModels.rooms {
                        var model = RoomModelGRDB(from: defaultModel)
                        try model.insert(db)
                    }
                }
                Logger.log("default \(DefaultModels.rooms.count) Rooms added", location: .GRDB, event: .success)
            }
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
