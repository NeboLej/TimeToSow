//
//  MyRoomRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation
import SwiftData

protocol MyRoomRepositoryProtocol {
//    func getCurrentRoom() -> UserMonthRoom
    func getCurrentRoom() async -> UserMonthRoom?
    func saveNewRoom(_ room: UserMonthRoom) async
}

final class MyRoomRepository: BaseRepository, MyRoomRepositoryProtocol {
    
    func getCurrentRoom() async -> UserMonthRoom? {
        do {
            var models: [MonthRoomModel] = try await database.fetchAll(MonthRoomModel.self)
            models.sort { $0.dateCreate > $1.dateCreate }
            if let model = models.first {
                return UserMonthRoom(from: model)
            } else {
                return nil
            }
        } catch {
            fatalError()
        }
    }
    
    func saveNewRoom(_ room: UserMonthRoom) async {
        do {
            let model = MonthRoomModel(from: room)
            try await database.insert(model)
        } catch {
            fatalError()
        }
    }
    
    let tmpShelf = ShelfType(name: "3", image: "shelf6", shelfPositions: [
        ShelfPosition(coefOffsetY: 0.208, paddingLeading: 28, paddingTrailing: 35),
        ShelfPosition(coefOffsetY: 0.43, paddingLeading: 212, paddingTrailing: 40),
        ShelfPosition(coefOffsetY: 0.525, paddingLeading: 36, paddingTrailing: 236),
        ShelfPosition(coefOffsetY: 0.606, paddingLeading: 195, paddingTrailing: 5),
        ShelfPosition(coefOffsetY: 0.935, paddingLeading: 5, paddingTrailing: 5),
       ])
    
    func getCurrentRoom() -> UserMonthRoom {
        
        let plants: [Plant] = [
//            Plant(seed: tmpSeed,
//                             pot: tmpPot,
//                             name: "test",
//                             description: "",
//                             offsetY: 200,
//                             offsetX: 150,
//                             notes: [Note(date: Date(), time: 100, tag: Tag(name: "Name", color: "#3D90D9"))])
          ]
        var plantDict: [UUID: Plant] = [:]
        plants.forEach {
            plantDict[$0.id] = $0
        }
        
        return UserMonthRoom(shelfType: tmpShelf,
                      roomType: .init(name: "May", image: "room8"),
                      name: "December",
                      dateCreate: Date(),
                      plants: plantDict
        )
    }
}

import GRDB

final class UserRoomRepository: MyRoomRepositoryProtocol {

    private let dbPool: DatabasePool
    
    init(dbPool: DatabasePool) {
        self.dbPool = dbPool
    }
    
    func getCurrentRoom() async -> UserMonthRoom? {
        do {
            let latest = try await dbPool.read { db in
                try UserRoomModelGRDB
//                    .order(Column("dateCreate").desc)
                    .limit(1)
                    .including(required: UserRoomModelGRDB.shelf)
                    .including(required: UserRoomModelGRDB.room)
                    .including(all: UserRoomModelGRDB.plants.including(required: PlantModelGRDB.seed)
                    .including(required: PlantModelGRDB.seed)
                    .including(required: PlantModelGRDB.pot)
                    .including(all: PlantModelGRDB.notes.including(required: NoteModelGRDB.tag)))
                    .fetchOne(db)
            }
            
            if let latest {
                return UserMonthRoom(from: latest)
            } else {
                return nil
            }
        } catch {
            fatalError()
        }
    }
    
    func saveNewRoom(_ room: UserMonthRoom) async {
        do {
            try await dbPool.write { db in
                var room = UserRoomModelGRDB(from1: room)
                try room.insert(db)
            }
        } catch {
            fatalError()
        }
    }
}
