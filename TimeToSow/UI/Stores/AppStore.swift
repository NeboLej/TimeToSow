//
//  AppStore.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

//import Foundation
import SwiftUI

@Observable
class AppStore {
    
    @ObservationIgnored
    private let myRoomRepository: MyRoomRepositoryProtocol
    @ObservationIgnored
    private let roomRepository: RoomRepositoryProtocol
    @ObservationIgnored
    private let shelfRepository: ShelfRepositoryProtocol
    
    var currentRoom: UserMonthRoom
    
    init(myRoomRepository: MyRoomRepositoryProtocol,
         roomRepository: RoomRepositoryProtocol,
         shelfRepository: ShelfRepositoryProtocol) {
        self.myRoomRepository = myRoomRepository
        self.roomRepository = roomRepository
        self.shelfRepository = shelfRepository
        currentRoom = myRoomRepository.getCurrentRoom()
    }
    
    func updateShelf() {
        currentRoom = myRoomRepository.getCurrentRoom()
    }
    
    func setRandomRoom() -> UserMonthRoom {
        currentRoom = currentRoom.copy(roomType: roomRepository.getRandomRoom(except: currentRoom.roomType))
        return currentRoom
    }
    
    func setRandomShelf() -> UserMonthRoom {
        currentRoom = currentRoom.copy(shelfType: shelfRepository.getRandomShelf(except: currentRoom.shelfType))
        return currentRoom
    }
    
    func newRandomPlant() {
        
    }
}
