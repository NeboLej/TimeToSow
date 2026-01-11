//
//  PotRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation
import GRDB

protocol PotRepositoryProtocol {
    func getRandomPotBy(rarity: Rarity, unavailablePotFeatures: [PotFeaturesType]) async -> Pot
}

final class PotRepository: BaseRepository, PotRepositoryProtocol {
    
    override func setDefaultValues() async {
        do {
            let existing = Set(try await dbPool.read {
                try String.fetchAll($0, sql: "SELECT stableId FROM pot")
            })

            let toInsert = DefaultModels.pots.filter { !existing.contains($0.stableId) }
            if toInsert.isEmpty { return }

            try await dbPool.write { db in
                for item in toInsert {
                    if try PotModelGRDB.filter(key: item.id).fetchCount(db) == 0 {
                        var pot = PotModelGRDB(from: item)
                        try pot.insert(db)
                    } else {
                        Logger.log("save new pot error, not uniqe", location: .GRDB, event: .error(nil))
                    }
                }
            }

            Logger.log("default \(toInsert.count) Pots added", location: .GRDB, event: .success)
        } catch {
            Logger.log("Failed to set default pots", location: .GRDB, event: .error(error))
        }
    }
    
    private func getAllPots() async throws -> [Pot] {
        try await dbPool.read { db in
            let pots = try PotModelGRDB.fetchAll(db).map { Pot(from: $0) }
            Logger.log("get \(pots.count) Pots", location: .GRDB, event: .success)
            return pots
        }
    }
    
    func getRandomPotBy(rarity: Rarity, unavailablePotFeatures: [PotFeaturesType]) async -> Pot {
        do {
            let matchingPots = try await dbPool.read { db in
                try PotModelGRDB
                    .filter(Column("rarity") == rarity.rawValue)
                    .fetchAll(db)
            }
            let availablePots = matchingPots.filter { pot in
                !pot.potFeatures.contains(where: unavailablePotFeatures.contains)
            }
            guard let randomPot = availablePots.randomElement() else {
                throw NSError(domain: "PotRepository", code: 1,
                              userInfo: [NSLocalizedDescriptionKey: "No available pot found for rarity \(rarity) excluding features \(unavailablePotFeatures)"]
                )
            }
            Logger.log("get pot by rarity", location: .GRDB, event: .success)
            return Pot(from: randomPot)
        } catch {
            Logger.log("Failed to get random Pot for rarity: \(rarity)", location: .GRDB, event: .error(error))
            fatalError()
        }
    }
}
