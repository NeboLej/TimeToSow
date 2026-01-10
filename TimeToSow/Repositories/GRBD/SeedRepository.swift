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
            let count = try await dbPool.read { db in
                try SeedModelGRDB.fetchCount(db)
            }
            
            if count == 0 {
                try await dbPool.write { db in
                    for defaultModel in DefaultModels.seeds {
                        var model = SeedModelGRDB(from1: defaultModel)
                        try model.insert(db)
                    }
                }
                Logger.log("default \(DefaultModels.seeds.count) Seeds added", location: .GRDB, event: .success)
            }
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
