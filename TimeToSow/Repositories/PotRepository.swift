//
//  PotRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol PotRepositoryProtocol {
    func getRandomPot() -> Pot
}

final class PotRepository: BaseRepository, PotRepositoryProtocol {
    
    func getRandomPot() -> Pot {
        pots.randomElement()!
    }
    
    private let pots: [Pot] = [
        Pot(potType: .medium,
            name: "aeded",
            image: "pot1",
            height: 20),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot2",
            height: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot3",
            height: 20),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot5",
            height: 22),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot6",
            height: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot7",
            height: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot8",
            height: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot9",
            height: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot10",
            height: 18),
        
        Pot(potType: .large,
            name: "aeded",
            image: "pot11",
            height: 35,
            anchorPointCoefficient: .init(x: 0, y: 0.23)),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot12",
            height: 30),
        
        Pot(potType: .small,
            name: "aeded",
            image: "pot13",
            height: 16,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "aeded",
            image: "pot14",
            height: 16,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "aeded",
            image: "pot15",
            height: 16,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "aeded",
            image: "pot16",
            height: 16,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "aeded",
            image: "pot17",
            height: 16,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "aeded",
            image: "pot18",
            height: 16,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "aeded",
            image: "pot19",
            height: 16,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "aeded",
            image: "pot20",
            height: 16,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot21",
            height: 24)
    ]
}
