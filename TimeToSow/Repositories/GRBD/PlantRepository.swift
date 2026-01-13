//
//  File.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation
import GRDB

protocol PlantRepositoryProtocol {
    func createRandomPlant(note: Note, roomID: UUID) async -> Plant
    func saveNewPlant(_ plant: Plant) async
    func getAllPlants() async -> [Plant]
    
    func updatePlant(_ plant: Plant) async
}

final class PlantRepository: BaseRepository, PlantRepositoryProtocol {
    private let seedRepository: SeedRepositoryProtocol
    private let potRepository: PotRepositoryProtocol
    
    init(dbPool: DatabasePool,seedRepository: SeedRepositoryProtocol, potRepository: PotRepositoryProtocol) {
        self.seedRepository = seedRepository
        self.potRepository = potRepository
        
        super.init(dbPool: dbPool)
    }
    
    func getAllPlants() async -> [Plant] {
        do {
            return try await dbPool.read { db in
                try PlantModelGRDB
                    .including(required: PlantModelGRDB.seed)
                    .including(required: PlantModelGRDB.pot)
                    .including(all: PlantModelGRDB.notes.including(required: NoteModelGRDB.tag))
                    .fetchAll(db)
                    .map { Plant(from: $0) }
            }
        } catch {
            fatalError()
        }
    }
    
    func createRandomPlant(note: Note, roomID: UUID) async -> Plant {
        let distributedTime = distributeTime(fullTime: note.time)
        let randomSeed = await seedRepository.getRandomSeedBy(rarity: distributedTime.seed)
        let randomPot = await potRepository.getRandomPotBy(rarity: distributedTime.pot, unavailablePotFeatures: randomSeed.unavailavlePotTypes)
        
        let name = [RemoteText.text(randomSeed.name), RemoteText.text(randomPot.name)].joined(separator: " ")
        return Plant(rootRoomID: roomID,
                     seed: randomSeed,
                     pot: randomPot,
                     name: name,
                     description: "",
                     offsetY: Double((10...250).randomElement()!),
                     offsetX: Double((10...350).randomElement()!),
                     notes: [note])
    }
    
    func updatePlant(_ plant: Plant) async {
        do {
            try await dbPool.write { db in
                if try PlantModelGRDB.filter(key: plant.id).fetchCount(db) != 0 {
                    let mutablePlant = PlantModelGRDB(from1: plant)
                    try mutablePlant.update(db)
                    Logger.log("update plant", location: .GRDB, event: .success)
                } else {
                    Logger.log("update plant error. plant not found", location: .GRDB, event: .error(nil))
                }
            }
        } catch {
            fatalError()
        }
    }
    
    func saveNote(_ note: Note, plantID: UUID) async throws {
        try await dbPool.write { db in
            var modelNote = NoteModelGRDB(from: note, plantID: plantID)
            try modelNote.insert(db)
            Logger.log("save new note", location: .GRDB, event: .success)
        }
    }
    
    func saveNewPlant(_ plant: Plant) async {
        do {
            try await dbPool.write { db in
                if try PlantModelGRDB.filter(key: plant.id).fetchCount(db) == 0 {
                    var mutablePlant = PlantModelGRDB(from1: plant)
                    try mutablePlant.insert(db)
                    Logger.log("save new plant", location: .GRDB, event: .success)
                } else {
                    Logger.log("save new plant error, plant not uniqe", location: .GRDB, event: .success)
                }
            }
            
            if let note = plant.notes.first {
                try await saveNote(note, plantID: plant.id)
            }
        } catch {
            fatalError()
        }
    }
    
    //MARK: - Private func
    
    func distributeTime(fullTime: Int) -> (seed: Rarity, pot: Rarity) {
        let variants = allVariantsRatityCombo(fullTime: fullTime)
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
