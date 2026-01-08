//
//  RoomRepository.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

protocol RoomRepositoryProtocol {
    func getRandomRoom(except: RoomType?) async -> RoomType
    func getAllRooms() async throws -> [RoomType]
//    func getRandomRoom(except: RoomType?) -> RoomType
//    func getNextRoom(curent: RoomType, isNext: Bool) -> RoomType
}

class RoomRepository: BaseRepository, RoomRepositoryProtocol {
    
    override init(database: DatabaseRepositoryProtocol) {
        super.init(database: database)
        setDefaultValues()
    }
    
    private func setDefaultValues() {
        Task {
            if try await database.fetchAll(RoomModel.self).isEmpty {
                try await database.insert(DefaultModels.rooms.map { RoomModel(from: $0) })
                print("💿 RoomRepository: --- default RoomModels added")
            }
        }
    }
    
    func getAllRooms() async throws -> [RoomType] {
        let roomModels: [RoomModel] = try await database.fetchAll(RoomModel.self)
        return roomModels.map { RoomType(from: $0) }
    }
    
    func getRandomRoom(except: RoomType?) async -> RoomType {
        do {
            let newShelf = try await getAllRooms().randomElement()!
            return newShelf != except ? newShelf : await getRandomRoom(except: except)
        } catch {
            fatalError()
        }
    }
    
    
//    func getRandomRoom(except: RoomType?) -> RoomType {
//        let newRoom = rooms.randomElement()!
//        return newRoom != except ? newRoom : getRandomRoom(except: except)
//    }
    
//    func getNextRoom(curent: RoomType, isNext: Bool) -> RoomType {
//        guard let index = rooms.firstIndex(of: curent) else { return rooms.first! }
//        
//        print(index)
//        if isNext {
//            if index + 1 <= rooms.count - 1 {
//                return rooms[index + 1]
//            } else {
//                return rooms[0]
//            }
//        } else {
//            if index - 1 >= 0 {
//                return rooms[index - 1]
//            } else {
//                return rooms.last!
//            }
//        }
//    }
}
