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
    
    override init(dbPool: DatabasePool) {
        super.init(dbPool: dbPool)
        Task {
            await setDefaultValues()
        }
    }

    private func setDefaultValues() async {
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
                print("💿 PotRepository: --- default Pots added")
            }
        } catch {
            print("💿 PotRepository: failed to set default pots — \(error)")
        }
    }
    
    private func getAllPots() async throws -> [Pot] {
        try await dbPool.read { db in
            try PotModelGRDB.fetchAll(db).map { Pot(from: $0) }
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
                throw NSError(
                    domain: "PotRepository",
                    code: 1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "No available pot found for rarity \(rarity) excluding features \(unavailablePotFeatures)"
                    ]
                )
            }
            
            return Pot(from: randomPot)
        } catch {
            fatalError()
        }

    }
}
