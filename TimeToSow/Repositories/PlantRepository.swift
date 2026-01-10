//
//  File.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol PlantRepositoryProtocol {
    func createRandomPlant(note: Note, roomID: UUID) async -> Plant
    func saveNewPlant(_ plant: Plant) async
    func getAllPlants() async -> [Plant]
    
    func updatePlant(_ plant: Plant) async
}
//
final class PlantRepository: BaseRepository, PlantRepositoryProtocol {
    func updatePlant(_ plant: Plant) async {
        
    }
    
    
    private let seedRepository: SeedRepositoryProtocol
    private let potRepository: PotRepositoryProtocol
    
    init(seedRepository: SeedRepositoryProtocol, potRepository: PotRepositoryProtocol, database: DatabaseRepositoryProtocol) {
        self.potRepository = potRepository
        self.seedRepository = seedRepository
        super.init(database: database)
    }
    
    func getAllPlants() async -> [Plant] {
        do {
            let plants = try await database.fetchAll(PlantModel.self)
            return plants.map { Plant(from: $0) }
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
    
    func saveNewPlant(_ plant: Plant) async {
        do {
            try await database.insert(PlantModel(from: plant))
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

import GRDB

final class PlantRepository1: PlantRepositoryProtocol {
    private let dbPool: DatabasePool
    private let seedRepository: SeedRepositoryProtocol
    private let potRepository: PotRepositoryProtocol
    
    init(dbPool: DatabasePool,seedRepository: SeedRepositoryProtocol, potRepository: PotRepositoryProtocol) {
        self.dbPool = dbPool
        self.seedRepository = seedRepository
        self.potRepository = potRepository
        
        getNotes()
    }
    
    // Все растения (с подгрузкой связанных данных — опционально)
    //    func getAllPlants() async throws -> [Plant] {
    //        try await dbPool.read { db in
    //            try PlantModelGRDB
    //                .including(required: PlantModelGRDB.seed)
    //                .including(required: PlantModelGRDB.pot)
    //                .including(all: PlantModelGRDB.notes.including(optional: NoteModelGRBD.tag))
    //                .fetchAll(db)
    //                .map { Plant(from: $0) }
    //        }
    //    }
    
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
    
    func getNotes() {
        Task {
            try await dbPool.read { db in
                let rows = try Row.fetchAll(db, sql: "SELECT date FROM note LIMIT 1")
                if let row = rows.first {
                    let value = row["date"]
                    print(value)
                    print(type(of: value))
                }
            }
            
            let ff = try await dbPool.read { db in
                try NoteModelGRDB
                    .including(required: NoteModelGRDB.tag)
                    .fetchAll(db)
            }
            print(ff)
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
    
    //    // Сохранение нового растения + начальной заметки + опционального тега к заметке
    
    func updatePlant(_ plant: Plant) async {
        do {
            try await dbPool.write { db in
                if try PlantModelGRDB.filter(key: plant.id).fetchCount(db) != 0 {
                    var mutablePlant = PlantModelGRDB(from1: plant)
                    print(mutablePlant.seedID)
                    print(mutablePlant.potID)
                    
                    try mutablePlant.update(db)
                }
            }
        } catch {
            fatalError()
        }
    }
    
    func saveNode(_ note: Note, plantID: UUID) async throws {
        try await dbPool.write { db in
            var modelNote = NoteModelGRDB(from: note, plantID: plantID)
            try modelNote.insert(db)
        }
    }
    
    func saveNewPlant(_ plant: Plant) async {
        do {
            try await dbPool.write { db in
                if try PlantModelGRDB.filter(key: plant.id).fetchCount(db) == 0 {
                    var mutablePlant = PlantModelGRDB(from1: plant)
                    try mutablePlant.insert(db)
                } else {
                    print("🌱 New Plant ERROR")
                }
                print("🌱 New Plant saved")
            }
            
            if let note = plant.notes.first {
                try await saveNode(note, plantID: plant.id)
            }
        } catch {
            fatalError()
        }
        
    }
    
    
    //    func getAllPlants() async throws -> [Plant] {
    //        try await dbPool.read { db in
    //            // Сначала загружаем обычные растения (без связанных объектов)
    //            var plantsGRDB = try PlantModelGRDB.fetchAll(db)
    //
    //            // Подгружаем связанные объекты (эффективно, пачками)
    //            try plantsGRDB.preload(db, PlantModelGRDB.seed)   // seed обязателен
    //            try plantsGRDB.preload(db, PlantModelGRDB.pot)    // pot обязателен
    //            try plantsGRDB.preload(db, PlantModelGRDB.notes.preloading(optional: NoteModelGRBD.tag))
    //
    //            // Теперь у каждого PlantModelGRDB есть заполненные свойства seed, pot, notes!
    //            return plantsGRDB.map { Plant(from: $0) }
    //        }
    //    }
    //    // Генерация случайного растения на основе заметки (как было раньше)
    //    func getRandomPlant(from note: Note) async throws -> Plant {
    //        let distributedTime = distributeTime(fullTime: note.time)  // твоя функция распределения
    //
    //        let randomSeed = try await seedRepository.getRandomSeed(by: distributedTime.seed)
    //        let randomPot = try await potRepository.getRandomPot(
    //            by: distributedTime.pot,
    //            excluding: randomSeed.unavailavlePotTypes
    //        )
    //
    //        let name = [RemoteText.text(randomSeed.name), RemoteText.text(randomPot.name)]
    //            .joined(separator: " ")
    //
    //        return Plant(
    //            id: UUID(),
    //            seedID: randomSeed.id,
    //            potID: randomPot.id,
    //            name: name,
    //            userDescription: "",
    //            offsetY: Double((10...250).randomElement()!),
    //            offsetX: Double((10...350).randomElement()!),
    //            time: note.time,
    //            rootRoomID: nil
    //            // notes добавим при сохранении
    //        )
    //    }
    
    
    
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
