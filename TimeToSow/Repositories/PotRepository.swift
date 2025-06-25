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
            width: 20),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot2",
            width: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot3",
            width: 20),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot5",
            width: 22),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot6",
            width: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot7",
            width: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot8",
            width: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot9",
            width: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot10",
            width: 18),
    ]
}
