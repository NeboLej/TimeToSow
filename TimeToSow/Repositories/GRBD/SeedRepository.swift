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
    
    override init(dbPool: DatabasePool) {
        super.init(dbPool: dbPool)
        
        Task {
            await setDefaultValues()
        }
    }
    
    private func setDefaultValues() async {
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
                print("💿 SeedRepository: --- default Seeds added")
            }
        } catch {
            print("💿 SeedRepository: failed to set default seeds — \(error)")
        }
    }
    
    func getAllSeeds() async throws -> [Seed] {
        try await dbPool.read { db in
            try SeedModelGRDB.fetchAll(db).map { Seed(from: $0) }
        }
    }
    
    func getRandomSeed() async throws -> Seed {
        let seeds = try await getAllSeeds()
        guard let randomSeed = seeds.randomElement() else {
            throw NSError(domain: "SeedRepository", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "No seeds available in database"
            ])
        }
        return randomSeed
    }
    
    func getRandomSeedBy(rarity: Rarity) async -> Seed {
        do {
            let seeds = try await dbPool.read { db in
                try SeedModelGRDB
                    .filter(Column("rarity") == rarity.rawValue)  // предполагаем, что Rarity — RawRepresentable<String>
                    .fetchAll(db)
            }
            
            guard let randomSeed = seeds.randomElement() else {
                throw NSError(domain: "SeedRepository", code: 2, userInfo: [
                    NSLocalizedDescriptionKey: "No seeds found with rarity \(rarity)"
                ])
            }
            return Seed(from: randomSeed)
        } catch {
            fatalError()
        }

    }
}
