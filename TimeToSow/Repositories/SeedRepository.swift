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
    
    func getRandomSeed() -> Seed {
        seeds.randomElement()!
    }
    
    func getRandomSeedBy(rarity: Rarity) -> Seed {
        seeds.filter{ $0.rarity == rarity }.randomElement()!
    }
    
    private let seeds: [Seed] = [
        
        Seed(name: "seed2.name",
             availavlePotTypes: PotType.allCases,
             image: "seed2",
             height: 40,
             rarity: .common),
        
        Seed(name: "seed3.name",
             availavlePotTypes: PotType.allCases,
             image: "seed3",
             height: 40,
             rarity: .common),
        
        Seed(name: "seed4.name",
             availavlePotTypes: PotType.allCases,
             image: "seed4",
             height: 45,
             rarity: .rare),
        
        Seed(name: "seed5.name",
             availavlePotTypes: PotType.allCases,
             image: "seed5",
             height: 40,
             rarity: .common),
        
        Seed(name: "seed6.name",
             availavlePotTypes: [.small, .large, .medium],
             image: "seed6",
             height: 40,
             rarity: .common,
             rootCoordinateCoef: CGPoint(x: 0, y: 0.3)),
        
        Seed(name: "seed7.name",
             availavlePotTypes: [.small, .large, .medium],
             image: "seed7",
             height: 40,
             rarity: .common,
             rootCoordinateCoef: .init(x: 0.2, y: 0.85)),
        
        Seed(name: "seed8.name",
             availavlePotTypes: [.large],
             image: "seed8",
             height: 100,
             rarity: .legendary),
        
        Seed(name: "seed9.name",
             availavlePotTypes: [.large],
             image: "seed9",
             height: 40,
             rarity: .legendary),
        
        Seed(name: "seed10.name",
             availavlePotTypes: [.large],
             image: "seed10",
             height: 100,
             rarity: .epic,
             rootCoordinateCoef: .init(x: -0.06, y: 0)),
        
        Seed(name: "seed11.name",
             availavlePotTypes: [.large],
             image: "seed11",
             height: 70,
             rarity: .rare),
        
        Seed(name: "seed12.name",
             availavlePotTypes: [.large],
             image: "seed12",
             height: 40,
             rarity: .rare),
        
        Seed(name: "seed13.name",
             availavlePotTypes: [.large],
             image: "seed13",
             height: 40,
             rarity: .rare),
        
        Seed(name: "seed14.name",
             availavlePotTypes: [.large],
             image: "seed14",
             height: 40,
             rarity: .epic),
        
        Seed(name: "seed15.name",
             availavlePotTypes: [.large],
             image: "seed15",
             height: 40,
             rarity: .rare),
        
        Seed(name: "seed16.name",
             availavlePotTypes: [.large],
             image: "seed16",
             height: 100,
             rarity: .legendary),
        
        Seed(name: "seed17.name",
             availavlePotTypes: [.large],
             image: "seed17",
             height: 40,
             rarity: .legendary,
             rootCoordinateCoef: .init(x: 0.05, y: 0)),
        
        Seed(name: "seed18.name",
             availavlePotTypes: [.large],
             image: "seed18",
             height: 44,
             rarity: .legendary,
             rootCoordinateCoef: .init(x: 0.1, y: 0)),
        
        Seed(name: "seed19.name",
             availavlePotTypes: PotType.allCases,
             image: "seed19",
             height: 20,
             rarity: .common),
        
        Seed(name: "seed20.name",
             availavlePotTypes: PotType.allCases,
             image: "seed20",
             height: 40,
             rarity: .rare,
             rootCoordinateCoef: .init(x: 0, y: 0.345)),
        
        Seed(name: "seed21.name",
             availavlePotTypes: PotType.allCases,
             image: "seed21",
             height: 32,
             rarity: .epic,
             rootCoordinateCoef: .init(x: 0,
                                       y: 0.03)),
        
        Seed(name: "seed22.name",
             availavlePotTypes: PotType.allCases,
             image: "seed22",
             height: 50,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0, y: 0.38)),
        
        Seed(name: "seed23.name",
             availavlePotTypes: PotType.allCases,
             image: "seed23",
             height: 45,
             rarity: .legendary),
        
        Seed(name: "seed24.name",
             availavlePotTypes: PotType.allCases,
             image: "seed24",
             height: 50,
             rarity: .epic),
        
        Seed(name: "seed25.name",
             availavlePotTypes: PotType.allCases,
             image: "seed25",
             height: 30,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0.1, y: 0)),
        
        Seed(name: "seed26.name",
             availavlePotTypes: PotType.allCases,
             image: "seed26",
             height: 90,
             rarity: .rare,
             rootCoordinateCoef: .init(x: 0, y: 0.93)),
        
        Seed(name: "seed27.name",
             availavlePotTypes: PotType.allCases,
             image: "seed27",
             height: 50,
             rarity: .epic,
             rootCoordinateCoef: .init(x: 0, y: 0.38)),
        
        Seed(name: "seed28.name",
             availavlePotTypes: PotType.allCases,
             image: "seed28",
             height: 130,
             rarity: .epic),
        
        Seed(name: "seed29.name",
             availavlePotTypes: PotType.allCases,
             image: "seed29",
             height: 35,
             rarity: .uncommon),
        
        Seed(name: "seed30.name",
             availavlePotTypes: PotType.allCases,
             image: "seed30",
             height: 35,
             rarity: .common,
             rootCoordinateCoef: .init(x: 0, y: 0.01)),
        
        Seed(name: "seed31.name",
             availavlePotTypes: PotType.allCases,
             image: "seed31",
             height: 40,
             rarity: .uncommon),
        
        Seed(name: "seed32.name",
             availavlePotTypes: PotType.allCases,
             image: "seed32",
             height: 28,
             rarity: .common),
        
        Seed(name: "seed33.name",
             availavlePotTypes: PotType.allCases,
             image: "seed33",
             height: 45,
             rarity: .rare,
             rootCoordinateCoef: .init(x: 0.1,
                                       y: 0.19)),
        
        Seed(name: "seed34.name",
             availavlePotTypes: PotType.allCases,
             image: "seed34",
             height: 45,
             rarity: .legendary),
        
        Seed(name: "seed35.name",
             availavlePotTypes: PotType.allCases,
             image: "seed35",
             height: 30,
             rarity: .rare)
    ]
}
