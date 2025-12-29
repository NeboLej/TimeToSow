//
//  PotRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol PotRepositoryProtocol {
    func getRandomPot() -> Pot
    func getRandomPotBy(rarity: Rarity) -> Pot
}

final class PotRepository: BaseRepository, PotRepositoryProtocol {
    
    func getRandomPot() -> Pot {
        pots.randomElement()!
    }
    
    func getRandomPotBy(rarity: Rarity) -> Pot {
        pots.filter{ $0.rarity == rarity }.randomElement()!
    }
    
    private let pots: [Pot] = [
        Pot(potType: .medium,
            name: "pot1.name",
            image: "pot1",
            height: 20,
            rarity: .common),
        
        Pot(potType: .medium,
            name: "pot2.name",
            image: "pot2",
            height: 25,
            rarity: .common),
        
        Pot(potType: .medium,
            name: "pot3.name",
            image: "pot3",
            height: 20,
            rarity: .common),
        
        Pot(potType: .medium,
            name: "pot5.name",
            image: "pot5",
            height: 22,
            rarity: .rare),
        
        Pot(potType: .medium,
            name: "pot6.name",
            image: "pot6",
            height: 25,
            rarity: .rare),
        
        Pot(potType: .medium,
            name: "pot7.name",
            image: "pot7",
            height: 25,
            rarity: .rare),
        
        Pot(potType: .medium,
            name: "pot8.name",
            image: "pot8",
            height: 25,
            rarity: .rare),
        
        Pot(potType: .medium,
            name: "pot9.name",
            image: "pot9",
            height: 25,
            rarity: .rare),
        
        Pot(potType: .medium,
            name: "pot10.name",
            image: "pot10",
            height: 18,
            rarity: .epic),
        
        Pot(potType: .large,
            name: "pot11.name",
            image: "pot11",
            height: 35,
            rarity: .legendary,
            anchorPointCoefficient: .init(x: 0, y: 0.23)),
        
        Pot(potType: .medium,
            name: "pot12.name",
            image: "pot12",
            height: 30,
            rarity: .epic),
        
        Pot(potType: .small,
            name: "pot13.name",
            image: "pot13",
            height: 16,
            rarity: .uncommon,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "pot14.name",
            image: "pot14",
            height: 16,
            rarity: .uncommon,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "pot15.name",
            image: "pot15",
            height: 16,
            rarity: .common,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "pot16.name",
            image: "pot16",
            height: 16,
            rarity: .common,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "pot17.name",
            image: "pot17",
            height: 16,
            rarity: .common,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "pot18.name",
            image: "pot18",
            height: 16,
            rarity: .common,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "pot19.name",
            image: "pot19",
            height: 16,
            rarity: .uncommon,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .small,
            name: "pot20.name",
            image: "pot20",
            height: 16,
            rarity: .uncommon,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(potType: .medium,
            name: "pot21.name",
            image: "pot21",
            height: 24,
            rarity: .legendary),
        
        Pot(potType: .small,
            name: "pot22.name",
            image: "pot22",
            height: 26,
            rarity: .uncommon),
        
        Pot(potType: .small,
            name: "pot23.name",
            image: "pot23",
            height: 20,
            rarity: .rare),
        
        Pot(potType: .small,
            name: "pot24.name",
            image: "pot24",
            height: 22,
            rarity: .legendary),
        
        Pot(potType: .small,
            name: "pot25.name",
            image: "pot25",
            height: 22,
            rarity: .uncommon),
        
        Pot(potType: .small,
            name: "pot26.name",
            image: "pot26",
            height: 25,
            rarity: .common),
        
        Pot(potType: .small,
            name: "pot27.name",
            image: "pot27",
            height: 18,
            rarity: .common,
            anchorPointCoefficient: .init(x: 0, y: 0.05)),
        
        Pot(potType: .small,
            name: "pot28.name",
            image: "pot28",
            height: 24,
            rarity: .common),
        
        Pot(potType: .small,
            name: "pot29.name",
            image: "pot29",
            height: 20,
            rarity: .common),
        
        Pot(potType: .small,
            name: "pot30.name",
            image: "pot30",
            height: 15,
            rarity: .common,
            anchorPointCoefficient: .init(x: -0.42, y: 0.15)),
        
        Pot(potType: .small,
            name: "pot31.name",
            image: "pot31",
            height: 26,
            rarity: .common),
        
        Pot(potType: .small,
            name: "pot32.name",
            image: "pot32",
            height: 23,
            rarity: .common),
        
        Pot(potType: .small,
            name: "pot33.name",
            image: "pot33",
            height: 23,
            rarity: .common),
        
        Pot(potType: .small,
            name: "pot34.name",
            image: "pot34",
            height: 23,
            rarity: .common),
        
        Pot(potType: .small,
            name: "pot35.name",
            image: "pot35",
            height: 23,
            rarity: .common),
        
        Pot(potType: .small,
            name: "pot36.name",
            image: "pot36",
            height: 25,
            rarity: .common,
            anchorPointCoefficient: .init(x: -0.32,
                                          y: 0.08)),
        
        Pot(potType: .small,
            name: "pot37.name",
            image: "pot37",
            height: 29,
            rarity: .common),
        
        Pot(potType: .small,
            name: "pot38.name",
            image: "pot38",
            height: 10,
            rarity: .common)
    ]
}
