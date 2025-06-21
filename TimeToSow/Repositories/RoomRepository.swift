//
//  RoomRepository.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

protocol RoomRepositoryProtocol {
    func getRandomRoom(except: RoomType?) -> RoomType
}

class RoomRepository: BaseRepository, RoomRepositoryProtocol {
    
    private var rooms: [RoomType] = [
        RoomType(name: "1", image: "room1"),
        RoomType(name: "2", image: "room2"),
        RoomType(name: "3", image: "room3"),
        
    ]
    
    func getRandomRoom(except: RoomType?) -> RoomType {
        let newRoom = rooms.randomElement()!
        return newRoom != except ? newRoom : getRandomRoom(except: except)
    }
}
