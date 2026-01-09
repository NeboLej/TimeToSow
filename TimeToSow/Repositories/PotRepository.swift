//
//  PotRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol PotRepositoryProtocol {
    func getRandomPotBy(rarity: Rarity, unavailablePotFeatures: [PotFeaturesType]) async -> Pot
}

final class PotRepository: BaseRepository, PotRepositoryProtocol {
    
    override init(database: DatabaseRepositoryProtocol) {
        super.init(database: database)
        setDefaultValues()
    }
    
    private func setDefaultValues() {
        Task {
            if try await database.fetchAll(PotModel.self).isEmpty {
                try await database.insert(DefaultModels.pots.map { PotModel(from: $0) })
                print("💿 PotRepository: --- default PotModels added")
            }
        }
    }
    
    func getRandomPotBy(rarity: Rarity, unavailablePotFeatures: [PotFeaturesType]) async -> Pot {
        do {
            let predicate = #Predicate<PotModel> {
                $0.rarityRaw == rarity.starCount 
            }
            let pots: [PotModel] = try await database.fetchAll(predicate: predicate)
            let unavailablePotFeaturesRaw = unavailablePotFeatures.map(\.rawValue)
            return Pot(from: pots.filter { !$0.potFeaturesTypeRow.contains(where: unavailablePotFeaturesRaw.contains) }.randomElement()!)
        } catch {
            fatalError()
        }
    }
}

import GRDB

final class PotRepository1: PotRepositoryProtocol {
    private let dbPool: DatabasePool
    
    init(dbPool: DatabasePool) {
        self.dbPool = dbPool
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
    
    // Основной метод: случайный горшок с фильтрацией по редкости и недоступным особенностям
    func getRandomPotBy(rarity: Rarity, unavailablePotFeatures: [PotFeaturesType]) async -> Pot {
        
        // Преобразуем недоступные особенности в их rawValue (предполагаем, что PotFeaturesType — RawRepresentable<String/Int>)
//        let unavailableRawValues = unavailablePotFeatures.map { $0.rawValue }
        
        do {
            let matchingPots = try await dbPool.read { db in
                try PotModelGRDB
                    .filter(Column("rarity") == rarity.rawValue)  // фильтр по редкости
                    .fetchAll(db)
            }
            
            // Фильтруем в памяти: горшок не должен содержать ни одну из недоступных особенностей
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
