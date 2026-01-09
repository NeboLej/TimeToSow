//
//  ShelfRepository.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

protocol ShelfRepositoryProtocol {
    func getRandomShelf() async -> ShelfType
}

class ShelfRepository: BaseRepository, ShelfRepositoryProtocol {
    
    override init(database: DatabaseRepositoryProtocol) {
        super.init(database: database)
        setDefaultValues()
    }
    
    private func setDefaultValues() {
        Task {
            if try await database.fetchAll(ShelfModel.self).isEmpty {
                try await database.insert(DefaultModels.shelfs.map { ShelfModel(from: $0) })
                print("💿 ShelfRepository: --- default ShelfModels added")
            }
        }
    }
    
    func getAllShelfs() async throws -> [ShelfType] {
        let shelfModels = try await database.fetchAll(ShelfModel.self)
        return shelfModels.map { ShelfType(from: $0) }
    }
    
    func getRandomShelf() async -> ShelfType {
        do {
            return try await getAllShelfs().randomElement()!
        } catch {
            fatalError()
        }
    }
}

import GRDB

class ShelfRepository1: BaseRepository1, ShelfRepositoryProtocol {
    
    override init(dbPool: DatabasePool) {
        super.init(dbPool: dbPool)
        
        Task {
            await setDefaultValues()
        }
    }
    
    private func setDefaultValues() async {
        do {
            let count = try await dbPool.read { db in
                try ShelfModelGRDB.fetchCount(db)
            }
            
            if count == 0 {
                try await dbPool.write { db in
                    for defaultShelf in DefaultModels.shelfs {
                        var shelf = ShelfModelGRDB(from: defaultShelf)
                        try shelf.insert(db)
                    }
                }
                print("💿 ShelfRepository: --- default Shelfs added")
            }
        } catch {
            print("💿 ShelfRepository: failed to set default shelfs — \(error)")
        }
    }
    
    func getAllShelfs() async throws -> [ShelfType] {
        try await dbPool.read { db in
            try ShelfModelGRDB.fetchAll(db).map { ShelfType(from: $0) }
        }
    }
    
    
    func getRandomShelf() async -> ShelfType {
        do {
            let models = try await getAllShelfs()
            guard let randomModel = models.randomElement() else {
                throw NSError(domain: "ShelfRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "No shelf available"])
            }
            return randomModel
        } catch {
            fatalError()
        }
    }
}
