//
//  File.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol PlantRepositoryProtocol {
    func getRandomPlant(note: Note) -> Plant
    //    func updatePlant(oldPlant: Plant, newNote: Note) -> Plant
}

final class PlantRepository: BaseRepository, PlantRepositoryProtocol {
    
    private let seedRepository: SeedRepositoryProtocol
    private let potRepository: PotRepositoryProtocol
    
    init(seedRepository: SeedRepositoryProtocol, potRepository: PotRepositoryProtocol) {
        self.potRepository = potRepository
        self.seedRepository = seedRepository
        super.init()
    }
    
    func getRandomPlant(note: Note) -> Plant {
        let distributedTime = distributeTime(fullTime: note.time)
        let randomSeed = seedRepository.getRandomSeedBy(rarity: distributedTime.seed)
        let randomPot = potRepository.getRandomPotBy(rarity: distributedTime.pot, unavailablePotFeatures: randomSeed.unavailavlePotTypes)
        let name = [RemoteText.text(randomSeed.name), RemoteText.text(randomPot.name)].joined(separator: " ")
        
        return Plant(seed: randomSeed,
                     pot: randomPot,
                     name: name,
                     description: "",
                     offsetY: Double((10...250).randomElement()!),
                     offsetX: Double((10...350).randomElement()!),
                     notes: [note])
    }
    
    //MARK: - Private func
    
    func distributeTime(fullTime: Int) -> (seed: Rarity, pot: Rarity) {
//        if fullTime < Rarity.SCALE_DIVISION_VALUE {
//            return (seed: .common, pot: .common)
//        }
//        
//        if fullTime >= Rarity.SCALE_DIVISION_VALUE * 8 {
//            return (seed: .legendary, pot: .legendary)
//        }
//        
//        let countDivisionValue: Int = fullTime / Rarity.SCALE_DIVISION_VALUE
//        
//        var variants: [[Int]] = []
//        
//        for first in 0...4 {
//            for second in 0...4 {
//                if first + second == countDivisionValue {
//                    variants.append([first, second])
//                }
//            }
//        }
//        
//        if variants.count == 0 { return (seed: .legendary, pot: .legendary) }
        
        let variants = allVariantsRatityCombo(fullTime: fullTime)
//        let randomCombo = variants.randomElement()!
        
        return variants.randomElement()!
    }
    
    func allVariantsRatityCombo(fullTime: Int) -> [(seed: Rarity, pot: Rarity)] {
        if fullTime < Rarity.SCALE_DIVISION_VALUE {
            return [(seed: .common, pot: .common)]
        }
        
        if fullTime >= Rarity.SCALE_DIVISION_VALUE * 8 {
            return [(seed: .legendary, pot: .legendary)]
        }
        
        let countDivisionValue: Int = fullTime / Rarity.SCALE_DIVISION_VALUE
        
        var variants: [[Int]] = []
        
        for first in 0...4 {
            for second in 0...4 {
                if first + second == countDivisionValue {
                    variants.append([first, second])
                }
            }
        }
        if variants.count == 0 { return [(seed: .legendary, pot: .legendary)] }
        
        return variants.map { (seed: getRarity($0[0]), pot: getRarity($0[1])) }
    }
    
    
    func getRarity(_ value: Int) -> Rarity {
        if value <= 0 { return .common }
        
        return switch value {
        case 1: .uncommon
        case 2: .rare
        case 3: .epic
        case 4: .legendary
        default: .legendary
        }
    }
}
