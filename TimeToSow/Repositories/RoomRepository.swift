//
//  RoomRepository.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

protocol RoomRepositoryProtocol {
    func getRandomRoom(except: RoomType?) -> RoomType
    func getNextRoom(curent: RoomType, isNext: Bool) -> RoomType
}

class RoomRepository: BaseRepository, RoomRepositoryProtocol {
    
    private var rooms: [RoomType] = [
        RoomType(name: "1", image: "room1"),
        RoomType(name: "3", image: "room7"),
        RoomType(name: "3", image: "room8"),
        RoomType(name: "3", image: "room9"),
        RoomType(name: "3", image: "room10"),
        RoomType(name: "3", image: "room11"),
        RoomType(name: "3", image: "room12"),
    ]
    
    func getRandomRoom(except: RoomType?) -> RoomType {
        let newRoom = rooms.randomElement()!
        return newRoom != except ? newRoom : getRandomRoom(except: except)
    }
    
    func getNextRoom(curent: RoomType, isNext: Bool) -> RoomType {
        guard let index = rooms.firstIndex(of: curent) else { return rooms.first! }
        
        print(index)
        if isNext {
            if index + 1 <= rooms.count - 1 {
                return rooms[index + 1]
            } else {
                return rooms[0]
            }
        } else {
            if index - 1 >= 0 {
                return rooms[index - 1]
            } else {
                return rooms.last!
            }
        }
    }
}
