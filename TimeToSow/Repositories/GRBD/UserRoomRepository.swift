//
//  MyRoomRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation
import GRDB

protocol UserRoomRepositoryProtocol {
    func getCurrentRoom() async -> UserRoom?
    func saveNewRoom(_ room: UserRoom) async
    func getUserRoomBy(by id: UUID) async -> UserRoom?
}

final class UserRoomRepository: BaseRepository, UserRoomRepositoryProtocol {
    
    func getCurrentRoom() async -> UserRoom? {
        do {
            let latest = try await dbPool.read { db in
                try UserRoomModelGRDB
                    .order(Column("dateCreate").desc)
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
                return UserRoom(from: latest)
            } else {
                return nil
            }
        } catch {
            fatalError()
        }
    }
    
    //это работает, но нужно додумывать репозиторий чтобы запрос текущего проходил через этот метод
    func getUserRoomBy(by id: UUID) async -> UserRoom? {
        do {
            let latest = try await dbPool.read { db in
                try UserRoomModelGRDB
                    .filter(Column("id") == id)
                    .including(required: UserRoomModelGRDB.shelf)
                    .including(required: UserRoomModelGRDB.room)
                    .including(all: UserRoomModelGRDB.plants.including(required: PlantModelGRDB.seed)
                    .including(required: PlantModelGRDB.seed)
                    .including(required: PlantModelGRDB.pot)
                    .including(all: PlantModelGRDB.notes.including(required: NoteModelGRDB.tag)))
                    .fetchOne(db)
            }
            
            if let latest {
                return UserRoom(from: latest)
            } else {
                return nil
            }
        } catch {
            fatalError()
        }
    }
    
    func saveNewRoom(_ room: UserRoom) async {
        do {
            try await dbPool.write { db in
                var room = UserRoomModelGRDB(from1: room)
                try room.insert(db)
                Logger.log("save new user room", location: .GRDB, event: .success)
            }
        } catch {
            Logger.log("Error saved new user room", location: .GRDB, event: .error(error))
            fatalError()
        }
    }
}
