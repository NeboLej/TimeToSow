//
//  PotRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol PotRepositoryProtocol {
    func getRandomPot() -> Pot
    func getRandomPotBy(rarity: Rarity, unavailablePotFeatures: [PotFeaturesType]) -> Pot
}

final class PotRepository: BaseRepository, PotRepositoryProtocol {
    
    func getRandomPot() -> Pot {
        pots.randomElement()!
    }
    
    func getRandomPotBy(rarity: Rarity, unavailablePotFeatures: [PotFeaturesType]) -> Pot {
        pots.filter { $0.rarity == rarity && !$0.potFeatures.contains(where: unavailablePotFeatures.contains) }.randomElement()!
    }
    
    let pots: [Pot] = [
        Pot(name: "pot1.name",
            image: "pot1",
            height: 20,
            rarity: .common),
        
        Pot(name: "pot2.name",
            image: "pot2",
            height: 25,
            rarity: .common),
        
        Pot(name: "pot3.name",
            image: "pot3",
            height: 20,
            rarity: .common),
        
        Pot(name: "pot5.name",
            image: "pot5",
            height: 22,
            rarity: .rare),
        
        Pot(name: "pot6.name",
            image: "pot6",
            height: 25,
            rarity: .rare),
        
        Pot(name: "pot7.name",
            image: "pot7",
            height: 25,
            rarity: .rare),
        
        Pot(name: "pot8.name",
            image: "pot8",
            height: 25,
            rarity: .rare),
        
        Pot(name: "pot9.name",
            image: "pot9",
            height: 25,
            rarity: .rare),
        
        Pot(potFeatures: [.narrow],
            name: "pot10.name",
            image: "pot10",
            height: 18,
            rarity: .epic),
        
        Pot(name: "pot11.name",
            image: "pot11",
            height: 35,
            rarity: .legendary,
            anchorPointCoefficient: .init(x: 0, y: 0.23)),
        
        Pot(name: "pot12.name",
            image: "pot12",
            height: 30,
            rarity: .epic),
        
        Pot(name: "pot13.name",
            image: "pot13",
            height: 16,
            rarity: .uncommon,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(name: "pot14.name",
            image: "pot14",
            height: 16,
            rarity: .uncommon,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(name: "pot15.name",
            image: "pot15",
            height: 16,
            rarity: .common,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(name: "pot16.name",
            image: "pot16",
            height: 16,
            rarity: .common,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(name: "pot17.name",
            image: "pot17",
            height: 16,
            rarity: .common,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(name: "pot18.name",
            image: "pot18",
            height: 16,
            rarity: .common,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(name: "pot19.name",
            image: "pot19",
            height: 16,
            rarity: .uncommon,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(name: "pot20.name",
            image: "pot20",
            height: 16,
            rarity: .uncommon,
            anchorPointCoefficient: .init(x: -0.15, y: 0)),
        
        Pot(name: "pot21.name",
            image: "pot21",
            height: 24,
            rarity: .legendary),
        
        Pot(name: "pot22.name",
            image: "pot22",
            height: 26,
            rarity: .uncommon),
        
        Pot(name: "pot23.name",
            image: "pot23",
            height: 20,
            rarity: .rare),
        
        Pot(name: "pot24.name",
            image: "pot24",
            height: 22,
            rarity: .legendary),
        
        Pot(name: "pot25.name",
            image: "pot25",
            height: 22,
            rarity: .uncommon),
        
        Pot(potFeatures: [.narrow],
            name: "pot26.name",
            image: "pot26",
            height: 25,
            rarity: .common),
        
        Pot(potFeatures: [.narrow],
            name: "pot27.name",
            image: "pot27",
            height: 18,
            rarity: .common,
            anchorPointCoefficient: .init(x: 0, y: 0.05)),
        
        Pot(potFeatures: [.narrow],
            name: "pot28.name",
            image: "pot28",
            height: 24,
            rarity: .common),
        
        Pot(potFeatures: [.narrow],
            name: "pot29.name",
            image: "pot29",
            height: 20,
            rarity: .common),
        
        Pot(potFeatures: [.narrow],
            name: "pot30.name",
            image: "pot30",
            height: 15,
            rarity: .common,
            anchorPointCoefficient: .init(x: -0.42, y: 0.15)),
        
        Pot(name: "pot31.name",
            image: "pot31",
            height: 26,
            rarity: .common),
        
        Pot(name: "pot32.name",
            image: "pot32",
            height: 23,
            rarity: .common),
        
        Pot(name: "pot33.name",
            image: "pot33",
            height: 23,
            rarity: .common),
        
        Pot(name: "pot34.name",
            image: "pot34",
            height: 23,
            rarity: .common),
        
        Pot(potFeatures: [],
            name: "pot35.name",
            image: "pot35",
            height: 23,
            rarity: .common),
        
        Pot(potFeatures: [.narrow],
            name: "pot36.name",
            image: "pot36",
            height: 25,
            rarity: .common,
            anchorPointCoefficient: .init(x: -0.32, y: 0.08)),
        
        Pot(potFeatures: [.narrow],
            name: "pot37.name",
            image: "pot37",
            height: 29,
            rarity: .common),
        
        Pot(name: "pot38.name",
            image: "pot38",
            height: 10,
            rarity: .common),
        
        Pot(potFeatures: [.narrow],
            name: "pot39.name",
            image: "pot39",
            height: 30,
            rarity: .epic),
        
        Pot(name: "pot40.name",
            image: "pot40",
            height: 25,
            rarity: .epic),
        
        Pot(name: "pot41.name",
            image: "pot41",
            height: 14,
            rarity: .rare,
            anchorPointCoefficient: .init(x: 0, y: 0.28)),
        
        Pot(potFeatures: [.narrow],
            name: "pot42.name",
            image: "pot42",
            height: 22,
            rarity: .common,
            anchorPointCoefficient: .init(x: 0, y: 0.18)),
        
        Pot(potFeatures: [],
            name: "pot43.name",
            image: "pot43",
            height: 25,
            rarity: .legendary),
        
        Pot(name: "pot44.name",
            image: "pot44",
            height: 40,
            rarity: .legendary,
            anchorPointCoefficient: .init(x: 0.05, y: 0)),
        
        Pot(name: "pot45.name",
            image: "pot45",
            height: 26,
            rarity: .uncommon),
        
        Pot(name: "pot46.name",
            image: "pot46",
            height: 25,
            rarity: .legendary),
        
        Pot(name: "pot47.name",
            image: "pot47",
            height: 25,
            rarity: .epic,
            anchorPointCoefficient: .init(x: 0, y: 0.02)),
        
        Pot(potFeatures: [.narrow],
            name: "pot48.name",
            image: "pot48",
            height: 30,
            rarity: .legendary),
        
        Pot(name: "pot49.name",
            image: "pot49",
            height: 20,
            rarity: .epic),
        
        Pot(potFeatures: [.narrow],
            name: "pot50.name",
            image: "pot50",
            height: 40,
            rarity: .legendary),
        
        Pot(potFeatures: [.narrow],
            name: "pot51.name",
            image: "pot51",
            height: 28,
            rarity: .uncommon,
            anchorPointCoefficient: .init(x: 0, y: 0.18)),
        
        Pot(potFeatures: [.narrow],
            name: "pot52.name",
            image: "pot52",
            height: 28,
            rarity: .uncommon,
            anchorPointCoefficient: .init(x: 0, y: 0.215)),
        
        Pot(potFeatures: [.narrow],
            name: "pot53.name",
            image: "pot53",
            height: 28,
            rarity: .uncommon,
            anchorPointCoefficient: .init(x: 0, y: 0.215)),
        
        Pot(potFeatures: [.narrow],
            name: "pot54.name",
            image: "pot54",
            height: 28,
            rarity: .rare,
            anchorPointCoefficient: .init(x: 0.1, y: 0.215)),
        
        Pot(potFeatures: [.narrow],
            name: "pot55.name",
            image: "pot55",
            height: 28,
            rarity: .rare,
            anchorPointCoefficient: .init(x: 0.1, y: 0.215)),
        
        Pot(potFeatures: [.narrow],
            name: "pot56.name",
            image: "pot56",
            height: 35,
            rarity: .rare),
        
        Pot(potFeatures: [.narrow],
            name: "pot57.name",
            image: "pot57",
            height: 18,
            rarity: .epic),
        
        Pot(potFeatures: [.narrow],
            name: "pot58.name",
            image: "pot58",
            height: 24,
            rarity: .rare)
    ]
}
