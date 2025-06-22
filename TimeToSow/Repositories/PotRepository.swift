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
            width: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot2",
            width: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot3",
            width: 25),
        
        Pot(potType: .medium,
            name: "aeded",
            image: "pot4",
            width: 30),
    ]
}
