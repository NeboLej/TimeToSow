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
    func getAllSimpleUserRooms() async -> [SimpleUserRoom]
    func updateRoom(_ room: UserRoom) async
}

final class UserRoomRepository: BaseRepository, UserRoomRepositoryProtocol {
    
    private let imagePrefetcher: PrefetcherImageProtocol
    
    init(dbPool: DatabasePool, imagePrefetcher: PrefetcherImageProtocol) {
        self.imagePrefetcher = imagePrefetcher
        super.init(dbPool: dbPool)
    }
    
    func getCurrentRoom() async -> UserRoom? {
        do {
            let latest = try await dbPool.read { db in
                try UserRoomModelGRDB
                    .order(Column("dateCreate").desc)
                    .limit(1)
                    .including(required: UserRoomModelGRDB.shelf)
                    .including(required: UserRoomModelGRDB.room)
                    .including(all: UserRoomModelGRDB.decors.including(required: DecorModelGRDB.decorType))
                    .including(all: UserRoomModelGRDB.plants
                        .including(required: PlantModelGRDB.seed)
                        .including(required: PlantModelGRDB.pot)
                        .including(all: PlantModelGRDB.notes.including(required: NoteModelGRDB.tag)))
                    .fetchOne(db)
            }
            
            if let latest {
                let room = UserRoom(from: latest)
                await imagePrefetcher.prefetchImages(imagePaths: room.decor.map { $0.value.decorType.resourceName })
                return room
            } else {
                return nil
            }
        } catch {
            fatalError()
        }
    }
    
    
    func updateRoom(_ room: UserRoom) async {
        do {
            try await dbPool.write { db in
                if try UserRoomModelGRDB.filter(key: room.id).fetchCount(db) != 0 {
                    let updatedRoom = UserRoomModelGRDB(from: room)
                    try updatedRoom.update(db)
                    Logger.log("update userRoom", location: .GRDB, event: .success)
                } else {
                    Logger.log("update userRoom error. user room not found", location: .GRDB, event: .error(nil))
                }
            }
        } catch {
            fatalError()
        }
    }
    
    func getAllSimpleUserRooms() async -> [SimpleUserRoom] {
        do {
            let rooms = try await dbPool.read { db in
                try UserRoomModelGRDB
                    .fetchAll(db)
                    .map { SimpleUserRoom(from: $0) }
            }
            Logger.log("\(rooms.count) simple userRooms fetched", location: .GRDB, event: .success)
            return rooms
        } catch {
            fatalError()
        }
    }
    
    //это работает, но нужно додумывать репозиторий чтобы запрос текущего проходил через этот метод
    func getUserRoomBy(by id: UUID) async -> UserRoom? {
        do {
            let roomModel = try await dbPool.read { db in
                try UserRoomModelGRDB
                    .filter(Column("id") == id)
                    .including(required: UserRoomModelGRDB.shelf)
                    .including(required: UserRoomModelGRDB.room)
                    .including(all: UserRoomModelGRDB.decors.including(required: DecorModelGRDB.decorType))
                    .including(all: UserRoomModelGRDB.plants
                        .including(required: PlantModelGRDB.seed)
                        .including(required: PlantModelGRDB.pot)
                        .including(all: PlantModelGRDB.notes.including(required: NoteModelGRDB.tag)))
                    .fetchOne(db)
            }
            
            if let roomModel {
                let room = UserRoom(from: roomModel)
                await imagePrefetcher.prefetchImages(imagePaths: room.decor.map { $0.value.decorType.resourceName })
                return room
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
                var room = UserRoomModelGRDB(from: room)
                try room.insert(db)
                Logger.log("save new user room", location: .GRDB, event: .success)
            }
        } catch {
            Logger.log("Error saved new user room", location: .GRDB, event: .error(error))
            fatalError()
        }
    }
}
