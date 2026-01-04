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
    
    let seeds: [Seed] = [
        
        Seed(name: "seed2.name",
             image: "seed2",
             height: 40,
             rarity: .common),
        
        Seed(name: "seed3.name",
             image: "seed3",
             height: 40,
             rarity: .common),
        
        Seed(name: "seed4.name",
             image: "seed4",
             height: 45,
             rarity: .rare,
             rootCoordinateCoef: .init(x: 0.05, y: 0)),
        
        Seed(name: "seed5.name",
             unavailavlePotTypes: [.narrow],
             image: "seed5",
             height: 40,
             rarity: .common),
        
        Seed(name: "seed6.name",
             image: "seed6",
             height: 40,
             rarity: .common,
             rootCoordinateCoef: CGPoint(x: 0, y: 0.28)),
        
        Seed(name: "seed7.name",
             image: "seed7",
             height: 40,
             rarity: .common,
             rootCoordinateCoef: .init(x: 0.2, y: 0.85)),
        
        Seed(name: "seed8.name",
             unavailavlePotTypes: [.narrow],
             image: "seed8",
             height: 100,
             rarity: .legendary),
        
        Seed(name: "seed9.name",
             image: "seed9",
             height: 40,
             rarity: .legendary),
        
        Seed(name: "seed10.name",
             image: "seed10",
             height: 90,
             rarity: .epic,
             rootCoordinateCoef: .init(x: -0.06, y: 0)),
        
        Seed(name: "seed11.name",
             unavailavlePotTypes: [.narrow],
             image: "seed11",
             height: 70,
             rarity: .rare),
        
        Seed(name: "seed12.name",
             image: "seed12",
             height: 40,
             rarity: .rare),
        
        Seed(name: "seed13.name",
             unavailavlePotTypes: [.narrow],
             image: "seed13",
             height: 40,
             rarity: .rare),
        
        Seed(name: "seed14.name",
             image: "seed14",
             height: 40,
             rarity: .epic),
        
        Seed(name: "seed15.name",
             unavailavlePotTypes: [.narrow],
             image: "seed15",
             height: 40,
             rarity: .rare),
        
        Seed(name: "seed16.name",
             image: "seed16",
             height: 90,
             rarity: .legendary,
             rootCoordinateCoef: .init(x: 0.011, y: 0)),
        
        Seed(name: "seed17.name",
             unavailavlePotTypes: [.narrow],
             image: "seed17",
             height: 35,
             rarity: .legendary,
             rootCoordinateCoef: .init(x: 0.05, y: 0)),
        
        Seed(name: "seed18.name",
             image: "seed18",
             height: 44,
             rarity: .legendary,
             rootCoordinateCoef: .init(x: 0.1, y: 0)),
        
        Seed(name: "seed19.name",
             image: "seed19",
             height: 20,
             rarity: .common),
        
        Seed(name: "seed20.name",
             image: "seed20",
             height: 40,
             rarity: .rare,
             rootCoordinateCoef: .init(x: 0, y: 0.345)),
        
        Seed(name: "seed21.name",
             image: "seed21",
             height: 32,
             rarity: .epic,
             rootCoordinateCoef: .init(x: 0, y: 0.03)),
        
        Seed(name: "seed22.name",
             image: "seed22",
             height: 50,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0, y: 0.46)),
        
        Seed(name: "seed23.name",
             image: "seed23",
             height: 45,
             rarity: .legendary),
        
        Seed(name: "seed24.name",
             image: "seed24",
             height: 50,
             rarity: .epic),
        
        Seed(name: "seed25.name",
             image: "seed25",
             height: 30,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0.1, y: 0)),
        
        Seed(name: "seed26.name",
             image: "seed26",
             height: 90,
             rarity: .rare,
             rootCoordinateCoef: .init(x: 0, y: 0.93)),
        
        Seed(name: "seed27.name",
             image: "seed27",
             height: 50,
             rarity: .epic,
             rootCoordinateCoef: .init(x: 0, y: 0.46)),
        
        Seed(name: "seed28.name",
             image: "seed28",
             height: 110,
             rarity: .epic),
        
        Seed(name: "seed29.name",
             image: "seed29",
             height: 35,
             rarity: .uncommon),
        
        Seed(name: "seed30.name",
             image: "seed30",
             height: 35,
             rarity: .common,
             rootCoordinateCoef: .init(x: 0, y: 0.01)),
        
        Seed(name: "seed31.name",
             image: "seed31",
             height: 40,
             rarity: .uncommon),
        
        Seed(name: "seed32.name",
             image: "seed32",
             height: 28,
             rarity: .common),
        
        Seed(name: "seed33.name",
             image: "seed33",
             height: 45,
             rarity: .rare,
             rootCoordinateCoef: .init(x: 0.1, y: 0.19)),
        
        Seed(name: "seed34.name",
             image: "seed34",
             height: 45,
             rarity: .legendary),
        
        Seed(name: "seed35.name",
             image: "seed35",
             height: 30,
             rarity: .rare),
        
        Seed(name: "seed36.name",
             unavailavlePotTypes: [.narrow],
             image: "seed36",
             height: 30,
             rarity: .uncommon),
        
        Seed(name: "seed37.name",
             unavailavlePotTypes: [.narrow],
             image: "seed37",
             height: 50,
             rarity: .epic,
             rootCoordinateCoef: .init(x: -0.05, y: 0)),
        
        Seed(name: "seed38.name",
             image: "seed38",
             height: 27,
             rarity: .common),
        
        Seed(name: "seed39.name",
             image: "seed39",
             height: 40,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0.05, y: 0)),
        
        Seed(name: "seed40.name",
             image: "seed40",
             height: 26,
             rarity: .common),
        
        Seed(name: "seed41.name",
             image: "seed41",
             height: 26,
             rarity: .common,
             rootCoordinateCoef: .init(x: 0.05, y: 0)),
        
        Seed(name: "seed42.name",
             image: "seed42",
             height: 22,
             rarity: .common),
        
        Seed(name: "seed43.name",
             unavailavlePotTypes: [.narrow],
             image: "seed43",
             height: 23,
             rarity: .uncommon),
        
        Seed(name: "seed44.name",
             image: "seed44",
             height: 38,
             rarity: .epic,
             rootCoordinateCoef: .init(x: -0.03, y: 0.13)),
        
        Seed(name: "seed45.name",
             image: "seed45",
             height: 44,
             rarity: .uncommon),
        
        Seed(name: "seed46.name",
             image: "seed46",
             height: 24,
             rarity: .uncommon),
        
        Seed(name: "seed47.name",
             image: "seed47",
             height: 24,
             rarity: .uncommon),
        
        Seed(name: "seed48.name",
             image: "seed48",
             height: 24,
             rarity: .uncommon),
        
        Seed(name: "seed49.name",
             image: "seed49",
             height: 24,
             rarity: .uncommon),
        
        Seed(name: "seed50.name",
             unavailavlePotTypes: [.narrow],
             image: "seed50",
             height: 42,
             rarity: .legendary),
        
        Seed(name: "seed51.name",
             image: "seed51",
             height: 37,
             rarity: .common),
        
        Seed(name: "seed52.name",
             image: "seed52",
             height: 68,
             rarity: .rare),
        
        Seed(name: "seed53.name",
             image: "seed53",
             height: 36,
             rarity: .rare,
             rootCoordinateCoef: .init(x: 0.08, y: 0)),
        
        Seed(name: "seed54.name",
             image: "seed54",
             height: 36,
             rarity: .rare),
        
        Seed(name: "seed55.name",
             image: "seed55",
             height: 32,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0, y: 0.15)),
        
        Seed(name: "seed56.name",
             image: "seed56",
             height: 32,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0, y: 0.15)),
        
        Seed(name: "seed57.name",
             image: "seed57",
             height: 32,
             rarity: .uncommon,
             rootCoordinateCoef: .init(x: 0, y: 0.15)),
        
        Seed(name: "seed58.name",
             image: "seed58",
             height: 36,
             rarity: .rare,
             rootCoordinateCoef: .init(x: -0.08, y: 0)),
        
        Seed(name: "seed59.name",
             unavailavlePotTypes: [.narrow],
             image: "seed59",
             height: 10,
             rarity: .common),
        
        Seed(name: "seed60.name",
             image: "seed60",
             height: 34,
             rarity: .uncommon),
        
        Seed(name: "seed61.name",
             image: "seed61",
             height: 28,
             rarity: .rare,
             rootCoordinateCoef: .init(x: -0.07, y: 0)),
        
        Seed(name: "seed62.name",
             image: "seed62",
             height: 60,
             rarity: .rare),
        
        Seed(name: "seed63.name",
             image: "seed63",
             height: 80,
             rarity: .epic),
        
        Seed(name: "seed64.name",
             unavailavlePotTypes: [.narrow],
             image: "seed64",
             height: 65,
             rarity: .epic,
             rootCoordinateCoef: .init(x: 0.08, y: 0)),
        
        Seed(name: "seed65.name",
             unavailavlePotTypes: [.narrow],
             image: "seed65",
             height: 32,
             rarity: .common)
    ]
}
