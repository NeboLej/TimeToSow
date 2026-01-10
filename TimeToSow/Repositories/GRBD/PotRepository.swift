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
            let count = try await dbPool.read { db in
                try PotModelGRDB.fetchCount(db)
            }
            
            if count == 0 {
                try await dbPool.write { db in
                    for defaultPot in DefaultModels.pots {
                        var pot = PotModelGRDB(from: defaultPot)
                        try pot.insert(db)
                    }
                }
                Logger.log("default \(DefaultModels.pots.count) Pots added", location: .GRDB, event: .success)
            }
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
