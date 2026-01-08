//
//  SeedRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol SeedRepositoryProtocol {
    func getRandomSeed() -> Seed
    func getRandomSeedBy(rarity: Rarity) -> Seed
}

final class SeedRepository: BaseRepository, SeedRepositoryProtocol {
    
    override init(database: DatabaseRepositoryProtocol) {
        super.init(database: database)
        setDefaultValues()
    }
    
    private func setDefaultValues() {
        Task {
            if try await database.fetchAll(SeedModel.self).isEmpty {
                try await database.insert(DefaultModels.seeds.map { SeedModel(from: $0) })
                print("💿 SeedRepository: --- default SeedModels added")
            }
        }
    }
    
    
    func getRandomSeed() -> Seed {
        DefaultModels.seeds.randomElement()!
    }
    
    func getRandomSeedBy(rarity: Rarity) -> Seed {
        DefaultModels.seeds.filter{ $0.rarity == rarity }.randomElement()!
    }
}
