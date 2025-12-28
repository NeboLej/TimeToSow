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
    private let plantRepository: PlantRepositoryProtocol
    @ObservationIgnored
    private let tagRepository: TagRepositoryProtocol
    
    var currentRoom: UserMonthRoom
    var selectedPlant: Plant?
    var appCoordinator: AppCoordinator = AppCoordinator()
    
    init(myRoomRepository: MyRoomRepositoryProtocol,
         roomRepository: RoomRepositoryProtocol,
         shelfRepository: ShelfRepositoryProtocol,
         plantRepository: PlantRepositoryProtocol,
         tagRepository: TagRepositoryProtocol) {
        self.myRoomRepository = myRoomRepository
        self.roomRepository = roomRepository
        self.shelfRepository = shelfRepository
        self.plantRepository = plantRepository
        self.tagRepository = tagRepository
        
        currentRoom = myRoomRepository.getCurrentRoom()
        addRandomPlantToShelf()
    }
    
    func send(_ action: AppAction) {
        switch action {
        case .selectPlant(let plant):
            if let plant {
                selectedPlant = currentRoom.plants[plant.id]
            } else {
                selectedPlant = nil
            }
        case .movePlant(plant: let plant, newPosition: let newPosition):
            guard let plant = currentRoom.plants[plant.id] else { return }
            let newPlant = plant.copy(offsetX: newPosition.x, offsetY: newPosition.y)
            currentRoom.plants[plant.id] = newPlant
        case .changedRoomType:
            setRandomRoom()
        case .changedShelfType:
            setRandomShelf()
        case .addRandomPlant:
            addRandomPlantToShelf()
        case .detailPlant(let plant):
            guard let plant = currentRoom.plants[plant.id] else { return }
            appCoordinator.navigate(to: .plantDetails(plant), modal: true)
        case .addRandomNote:
            guard let selectedPlant else { return }
            let newNotes = getRandomNote()
            var notes = selectedPlant.notes
            notes.append(newNotes)
            let newPlant = selectedPlant.copy(notes: notes)
            self.selectedPlant = newPlant
            currentRoom.plants[selectedPlant.id] = newPlant
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
        let randomPlant = plantRepository.getRandomPlant(note: getRandomNote())
        updatePlant(with: randomPlant)
        return randomPlant
    }
    
    func getRandomNote() -> Note {
        Note(date: Date().getOffsetDate(offset: (-5...0).randomElement()!),
             time: (5...260).randomElement()!,
             tag: tagRepository.getRandomTag())
    }
    
    func newRandomPlant() {
        
    }
    
    // MARK: - END TMP
}

//MARK: Test -
extension AppStore {
    func setRandomRoom() {
        currentRoom.roomType = roomRepository.getRandomRoom(except: currentRoom.roomType)
    }
    
    func setRandomShelf() {
        currentRoom.shelfType = shelfRepository.getRandomShelf(except: currentRoom.shelfType)
    }
    
    func addRandomPlantToShelf()  {
        let randomPlant = plantRepository.getRandomPlant(note: getRandomNote())
        updatePlant(with: randomPlant)
    }
}
