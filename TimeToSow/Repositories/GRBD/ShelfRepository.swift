//
//  ShelfRepository.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation
import GRDB

protocol ShelfRepositoryProtocol {
    func getRandomShelf() async -> ShelfType
    func getAllShelfs() async -> [ShelfType]
}

final class ShelfRepository: BaseRepository, ShelfRepositoryProtocol {
    
    override func setDefaultValues() async {
        do {
            let existing = Set(try await dbPool.read {
                try String.fetchAll($0, sql: "SELECT stableId FROM shelf")
            })
            
            let toInsert = DefaultModels.shelfs.filter { !existing.contains($0.stableId) }
            if toInsert.isEmpty { return }
            
            try await dbPool.write { db in
                for item in toInsert {
                    if try ShelfModelGRDB.filter(key: item.id).fetchCount(db) == 0 {
                        var shelf = ShelfModelGRDB(from: item)
                        try shelf.insert(db)
                    } else {
                        Logger.log("save new shelf error, not uniqe", location: .GRDB, event: .error(nil))
                    }
                }
            }
            Logger.log("default \(toInsert.count) Shelfs added", location: .GRDB, event: .success)
        } catch {
            Logger.log("Failed to set default shelfs", location: .GRDB, event: .error(error))
        }
    }
    
    func getAllShelfs() async -> [ShelfType] {
        do {
            return try await dbPool.read { db in
                let models = try ShelfModelGRDB.fetchAll(db).map { ShelfType(from: $0) }
                Logger.log("get \(models.count) Shelf", location: .GRDB, event: .success)
                return models
            }
        } catch {
            Logger.log("Failed to get Rooms", location: .GRDB, event: .error(error))
            return []
        }
    }
    
    func getRandomShelf() async -> ShelfType {
        do {
            let models = await getAllShelfs()
            guard let randomModel = models.randomElement() else {
                throw NSError(domain: "ShelfRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "No shelf available"])
            }
            Logger.log("get random shelf", location: .GRDB, event: .success)
            return randomModel
        } catch {
            Logger.log("Failed to get random Shelf", location: .GRDB, event: .error(error))
            fatalError()
        }
    }
}
