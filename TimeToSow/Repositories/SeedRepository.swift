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
             width: 45,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed5",
             width: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.small, .large, .medium],
             image: "seed6",
             width: 40,
             rootCoordinateCoef: CGPoint(x: 0, y: 0.3),
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.small, .large, .medium],
             image: "seed7",
             width: 40,
             rootCoordinateCoef: .init(x: 0.2, y: 0.85),
             startTimeInterval: 10,
             endTimeInterval: 100),
    ]
}
