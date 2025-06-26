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
    @ObservationIgnored
    private let seedRepository: SeedRepositoryProtocol
    @ObservationIgnored
    private let potRepository: PotRepositoryProtocol
    
    var currentRoom: UserMonthRoom
    
    init(myRoomRepository: MyRoomRepositoryProtocol,
         roomRepository: RoomRepositoryProtocol,
         shelfRepository: ShelfRepositoryProtocol,
         seedRepository: SeedRepositoryProtocol,
         potRepository: PotRepositoryProtocol) {
        self.myRoomRepository = myRoomRepository
        self.roomRepository = roomRepository
        self.shelfRepository = shelfRepository
        self.seedRepository = seedRepository
        self.potRepository = potRepository
        currentRoom = myRoomRepository.getCurrentRoom()
    }
    
    func updateShelf() {
        currentRoom = myRoomRepository.getCurrentRoom()
    }
    
    func setShelf(roomType: RoomType? = nil, shelfType: ShelfType? = nil) {
        currentRoom = currentRoom.copy(shelfType: shelfType ?? currentRoom.shelfType, roomType: roomType ?? currentRoom.roomType)
    }
    
    func getNextRoom(currentRoom: RoomType, isNext: Bool) -> RoomType {
        roomRepository.getNextRoom(curent: currentRoom, isNext: isNext)
    }
    
    func getNextShelf(currentShelf: ShelfType, isNext: Bool) -> ShelfType {
        shelfRepository.getNextShelf(curent: currentShelf, isNext: isNext)
    }
    
    func newRandomPlant() {
        
    }
}

//MARK: Test -
extension AppStore {
    func setRandomRoom() -> UserMonthRoom {
        currentRoom = currentRoom.copy(roomType: roomRepository.getRandomRoom(except: currentRoom.roomType))
        return currentRoom
    }
    
    func setRandomShelf() -> UserMonthRoom {
        currentRoom = currentRoom.copy(shelfType: shelfRepository.getRandomShelf(except: currentRoom.shelfType))
        return currentRoom
    }
    
    func addRandomPlantToShelf() -> UserMonthRoom  {
        let randomPlant = Plant(seed: seedRepository.getRandomSeed(),
                                pot: potRepository.getRandomPot(),
                                tag: .init(name: "", color: ""),
                                line: (0...currentRoom.shelfType.shelfPositions.count).randomElement()!,
                                offsetX: Double((10...350).randomElement()!))
        currentRoom = currentRoom.copy(plants: currentRoom.plants + [randomPlant])
        return currentRoom
    }
}
