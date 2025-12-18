//
//  AppStore.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

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
    var selectedPlant: Plant?
    
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
    
    func send(_ action: AppAction) {
        switch action {
        case .selectPlant(let plant):
            selectedPlant = plant
        case .movePlant(plant: let plant, newPosition: let newPosition):
            currentRoom.plants[plant.id] = plant.copy(offsetX: newPosition.x, offsetY: newPosition.y)
        }
    }
    
    // MARK: - TMP
    
    func updateShelf() {
        currentRoom = myRoomRepository.getCurrentRoom()
    }
    
    func setShelf(roomType: RoomType? = nil, shelfType: ShelfType? = nil) {
        currentRoom.shelfType = shelfType ?? currentRoom.shelfType
        currentRoom.roomType = roomType ?? currentRoom.roomType
    }
    
    func getNextRoom(currentRoom: RoomType, isNext: Bool) -> RoomType {
        roomRepository.getNextRoom(curent: currentRoom, isNext: isNext)
    }
    
    func getNextShelf(currentShelf: ShelfType, isNext: Bool) -> ShelfType {
        shelfRepository.getNextShelf(curent: currentShelf, isNext: isNext)
    }
    
    func updatePlant(with newPlant: Plant) {
        currentRoom.plants[newPlant.id] = newPlant
    }
    
    func getRandomPlant() -> Plant {
        let randomPlant = Plant(seed: seedRepository.getRandomSeed(),
                                pot: potRepository.getRandomPot(),
                                tag: .init(name: "", color: ""),
                                offsetX: Double((10...350).randomElement()!),
                                offsetY: Double((10...250).randomElement()!))
        updatePlant(with: randomPlant)
        return randomPlant
    }
    
    func newRandomPlant() {
        
    }
    
    // MARK: - END TMP
}

//MARK: Test -
extension AppStore {
    func setRandomRoom() -> UserMonthRoom {
        currentRoom = currentRoom.copy(roomType: roomRepository.getRandomRoom(except: currentRoom.roomType))
        return currentRoom
    }
    
    func setRandomShelf() -> UserMonthRoom {
        currentRoom.shelfType = shelfRepository.getRandomShelf(except: currentRoom.shelfType) //currentRoom.copy(shelfType: shelfRepository.getRandomShelf(except: currentRoom.shelfType))
        return currentRoom
    }
    
    func addRandomPlantToShelf() -> UserMonthRoom  {
        let randomPlant = Plant(seed: seedRepository.getRandomSeed(),
                                pot: potRepository.getRandomPot(),
                                tag: .init(name: "", color: ""),
                                offsetX: Double((10...350).randomElement()!),
                                offsetY: Double((10...250).randomElement()!))
        updatePlant(with: randomPlant)
        return currentRoom
    }
}
