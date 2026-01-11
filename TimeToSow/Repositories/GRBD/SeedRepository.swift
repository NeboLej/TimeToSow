//
//  SeedRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation
import GRDB

protocol SeedRepositoryProtocol {
    func getRandomSeedBy(rarity: Rarity) async -> Seed
}

final class SeedRepository: BaseRepository, SeedRepositoryProtocol {
    
    override func setDefaultValues() async {
        do {
            let existing = Set(try await dbPool.read {
                try String.fetchAll($0, sql: "SELECT stableId FROM seed")
            })
            
            let toInsert = DefaultModels.seeds.filter { !existing.contains($0.stableId) }
            if toInsert.isEmpty { return }
            
            try await dbPool.write { db in
                for item in toInsert {
                    if try SeedModelGRDB.filter(key: item.id).fetchCount(db) == 0 {
                        var seed = SeedModelGRDB(from: item)
                        try seed.insert(db)
                    } else {
                        Logger.log("save new seed error, not uniqe", location: .GRDB, event: .error(nil))
                    }
                }
            }
            
            Logger.log("default \(toInsert.count) Seeds added", location: .GRDB, event: .success)
        } catch {
            Logger.log("Failed to set default Seeds", location: .GRDB, event: .error(error))
        }
    }
    
    func getAllSeeds() async throws -> [Seed] {
        try await dbPool.read { db in
            let seeds = try SeedModelGRDB.fetchAll(db).map { Seed(from: $0) }
            Logger.log("get \(seeds.count) Seeds", location: .GRDB, event: .success)
            return seeds
        }
    }
    
    func getRandomSeedBy(rarity: Rarity) async -> Seed {
        do {
            let seeds = try await dbPool.read { db in
                try SeedModelGRDB
                    .filter(Column("rarity") == rarity.rawValue)
                    .fetchAll(db)
            }
            
            guard let randomSeed = seeds.randomElement() else {
                throw NSError(domain: "SeedRepository", code: 2, userInfo: [
                    NSLocalizedDescriptionKey: "No seeds found with rarity \(rarity)"
                ])
            }
            Logger.log("get seed by rarity", location: .GRDB, event: .success)
            return Seed(from: randomSeed)
        } catch {
            Logger.log("Failed to get random Seed for rarity: \(rarity)", location: .GRDB, event: .error(error))
            fatalError()
        }
        
    }
}
