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

class RoomRepository: BaseRepository, RoomRepositoryProtocol {
    
    override init(dbPool: DatabasePool) {
        super.init(dbPool: dbPool)
        
        Task {
            await setDefaultValues()
        }
    }
    
    private func setDefaultValues() async {
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
                print("💿 ShelfRepository: --- default Shelfs added")
            }
        } catch {
            print("💿 ShelfRepository: failed to set default shelfs — \(error)")
        }
    }
    
    func getAllRooms() async throws -> [RoomType] {
        try await dbPool.read { db in
            try RoomModelGRDB.fetchAll(db).map { RoomType(from: $0) }
        }
    }
    
    func getRandomRoom() async -> RoomType {
        do {
            let models = try await getAllRooms()
            guard let randomModel = models.randomElement() else {
                throw NSError(domain: "RoomRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "No room available"])
            }
            return randomModel
        } catch {
            fatalError()
        }
    }

}
