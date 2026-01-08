//
//  PotRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol PotRepositoryProtocol {
    func getRandomPot() -> Pot
    func getRandomPotBy(rarity: Rarity, unavailablePotFeatures: [PotFeaturesType]) async -> Pot
//    func getRandomPotBy(rarity: Rarity, unavailablePotFeatures: [PotFeaturesType]) -> Pot
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
    
    func getRandomPot() -> Pot {
        DefaultModels.pots.randomElement()!
    }
    
    func getRandomPotBy(rarity: Rarity, unavailablePotFeatures: [PotFeaturesType]) -> Pot {
        DefaultModels.pots.filter { $0.rarity == rarity && !$0.potFeatures.contains(where: unavailablePotFeatures.contains) }.randomElement()!
    }
}
