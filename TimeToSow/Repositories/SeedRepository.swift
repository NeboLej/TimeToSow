//
//  SeedRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol SeedRepositoryProtocol {
    func getRandomSeed() -> Seed
}

final class SeedRepository: BaseRepository, SeedRepositoryProtocol {
    
    func getRandomSeed() -> Seed {
        seeds.randomElement()!
    }
    
    private let seeds: [Seed] = [
        Seed(name: "asasd",
             availavlePotTypes: PotType.allCases,
             image: "seed1",
             width: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd",
             availavlePotTypes: PotType.allCases,
             image: "seed1",
             width: 25,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed2",
             width: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed3",
             width: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed4",
             width: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed5",
             width: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
    ]
}
