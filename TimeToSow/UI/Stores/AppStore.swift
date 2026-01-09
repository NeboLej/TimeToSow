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
    
    var currentRoom: UserMonthRoom = .empty
    var selectedPlant: Plant?
    var appCoordinator: AppCoordinator = AppCoordinator()
    var selectedTag: Tag?
    
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
        
        
        
//        getData()
        
        

//        addRandomPlantToShelf()
    }
    
    func getData() {
        Task { 
            selectedTag = await tagRepository.getRandomTag()
            let lastRoom = await myRoomRepository.getCurrentRoom()
//            let allPlants = await plantRepository.getAllPlants()
            
            if let lastRoom {
                currentRoom = lastRoom
            } else {
                currentRoom = await createNewMonthRoom()
                await myRoomRepository.saveNewRoom(currentRoom)
            }
            
//            allPlants.forEach {
//                currentRoom.plants[$0.id] = $0
//            }
            
        }
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
            saveNewPlant(newPlant)
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
        case .toDebugScreen:
            appCoordinator.activeSheet = .debugScreen
        case .addNewPlant(let plant):
            saveNewPlant(plant)
        }
    }
    
    func createNewMonthRoom() async -> UserMonthRoom {
        let randomRoom = await roomRepository.getRandomRoom(except: nil)
        let randomShelf = await shelfRepository.getRandomShelf(except: nil)
        
        return UserMonthRoom(shelfType: randomShelf, roomType: randomRoom, name: Date().toReadableDate(), dateCreate: Date(), plants: [:])
    }
    
    // MARK: - TMP
    
//    func updateShelf() {
//        currentRoom = myRoomRepository.getCurrentRoom()
//    }
    
//    func setShelf(roomType: RoomType? = nil, shelfType: ShelfType? = nil) {
//        currentRoom?.shelfType = shelfType ?? currentRoom?.shelfType
//        currentRoom?.roomType = roomType ?? currentRoom?.roomType
//    }
    
//    func getNextRoom(currentRoom: RoomType, isNext: Bool) -> RoomType {
//        roomRepository.getNextRoom(curent: currentRoom, isNext: isNext)
//    }
    
//    func getNextShelf(currentShelf: ShelfType, isNext: Bool) -> ShelfType {
//        shelfRepository.getNextShelf(curent: currentShelf, isNext: isNext)
//    }
    
    func updateCurrentRoom() {
        
    }
    
    func saveNewPlant(_ newPlant: Plant) {
        currentRoom.plants[newPlant.id] = newPlant
        Task {
            await myRoomRepository.saveNewRoom(currentRoom)
//            await plantRepository.saveNewPlant(newPlant)
        }
    }
    
    func getRandomPlant(note: Note) async -> Plant {
        let randomPlant = await plantRepository.getRandomPlant(note: note)
        return randomPlant
    }
    
    func getRandomNote() -> Note {
        guard let selectedTag else { fatalError() }
        return Note(date: Date().getOffsetDate(offset: (-5...0).randomElement()!),
             time: (5...240).randomElement()!,
             tag: selectedTag)
    }
    
    func newRandomPlant() {
        
    }
    
    // MARK: - END TMP
}

//MARK: Test -
extension AppStore {
    func setRandomRoom() {
        Task {
            currentRoom.roomType = await roomRepository.getRandomRoom(except: currentRoom.roomType)
        }
    }
    
    func setRandomShelf() {
        Task {
            currentRoom.shelfType = await shelfRepository.getRandomShelf(except: currentRoom.shelfType)
        }
        
    }
    
    func addRandomPlantToShelf() {
        Task {
            let randomPlant = await plantRepository.getRandomPlant(note: getRandomNote())
            saveNewPlant(randomPlant)
        }
    }
}
