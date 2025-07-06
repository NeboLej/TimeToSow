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
             height: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed3",
             height: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed4",
             height: 45,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed5",
             height: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.small, .large, .medium],
             image: "seed6",
             height: 40,
             rootCoordinateCoef: CGPoint(x: 0, y: 0.3),
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.small, .large, .medium],
             image: "seed7",
             height: 40,
             rootCoordinateCoef: .init(x: 0.2, y: 0.85),
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.large],
             image: "seed8",
             height: 100,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.large],
             image: "seed9",
             height: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.large],
             image: "seed10",
             height: 100,
             rootCoordinateCoef: .init(x: -0.06, y: 0),
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.large],
             image: "seed11",
             height: 100,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.large],
             image: "seed12",
             height: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd13",
             availavlePotTypes: [.large],
             image: "seed13",
             height: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd14",
             availavlePotTypes: [.large],
             image: "seed14",
             height: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.large],
             image: "seed15",
             height: 40,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.large],
             image: "seed16",
             height: 100,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.large],
             image: "seed17",
             height: 40,
             rootCoordinateCoef: .init(x: 0.05, y: 0),
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "asasd2",
             availavlePotTypes: [.large],
             image: "seed18",
             height: 44,
             rootCoordinateCoef: .init(x: 0.1, y: 0),
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed19",
             height: 20,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed20",
             height: 40,
             rootCoordinateCoef: .init(x: 0, y: 0.345),
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed21",
             height: 32,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed22",
             height: 50,
             rootCoordinateCoef: .init(x: 0, y: 0.38),
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed23",
             height: 45,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed24",
             height: 50,
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed25",
             height: 30,
             rootCoordinateCoef: .init(x: 0.1, y: 0),
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed26",
             height: 90,
             rootCoordinateCoef: .init(x: 0, y: 0.93),
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed27",
             height: 50,
             rootCoordinateCoef: .init(x: 0, y: 0.38),
             startTimeInterval: 10,
             endTimeInterval: 100),
        
        Seed(name: "qwe",
             availavlePotTypes: PotType.allCases,
             image: "seed28",
             height: 130,
             startTimeInterval: 10,
             endTimeInterval: 100)
    ]
}
