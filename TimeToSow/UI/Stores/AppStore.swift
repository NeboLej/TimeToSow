//
//  AppStore.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI
import GRDB

@Observable
class AppStore {
    
    @ObservationIgnored
    private let myRoomRepository: UserRoomRepositoryProtocol
    @ObservationIgnored
    private let roomRepository: RoomRepositoryProtocol
    @ObservationIgnored
    private let shelfRepository: ShelfRepositoryProtocol
    @ObservationIgnored
    private let plantRepository: PlantRepositoryProtocol
    @ObservationIgnored
    private let tagRepository: TagRepositoryProtocol
    
    var currentRoom: UserRoom = .empty
    var selectedPlant: Plant?
    var appCoordinator: AppCoordinator = AppCoordinator()
    var selectedTag: Tag?
    var simpleUserRooms: [SimpleUserRoom] = []
    var userRooms: [UUID: UserRoom] = [:]
    
    init(myRoomRepository: UserRoomRepositoryProtocol,
         roomRepository: RoomRepositoryProtocol,
         shelfRepository: ShelfRepositoryProtocol,
         plantRepository: PlantRepositoryProtocol,
         tagRepository: TagRepositoryProtocol) {
        self.myRoomRepository = myRoomRepository
        self.roomRepository = roomRepository
        self.shelfRepository = shelfRepository
        self.plantRepository = plantRepository
        self.tagRepository = tagRepository
        
        getData()
    }
    
    func send(_ action: AppAction) {
        switch action {
        case .selectPlant(let plant):
            if let plant {
                selectedPlant = userRooms[plant.rootRoomID]?.plants[plant.id]
            } else {
                selectedPlant = nil
            }
        case .movePlant(plant: let plant, newPosition: let newPosition):
            updatePlantPosition(plant, newPosition: newPosition)
        case .changedRoomType:
            setRandomRoom()
        case .changedShelfType:
            setRandomShelf()
        case .addRandomPlant:
            addRandomPlantToShelf()
        case .detailPlant(let plant):
            guard let plant = userRooms[plant.rootRoomID]?.plants[plant.id] else { return }
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
        case .getUserRoom(let id):
            getUserRoom(by: id)
        }
    }
    
    func getData() {
        Task {
//            let newRoom = await createNewUserRoom()
//            await myRoomRepository.saveNewRoom(newRoom)
            
            selectedTag = await tagRepository.getRandomTag()
            let lastRoom = await myRoomRepository.getCurrentRoom()
            if let lastRoom {
                currentRoom = lastRoom
            } else {
                currentRoom = await createNewUserRoom()
                await myRoomRepository.saveNewRoom(currentRoom)
            }
            userRooms[currentRoom.id] = currentRoom
            simpleUserRooms = await myRoomRepository.getAllSimpleUserRooms()
        }
    }
    
    func createNewUserRoom() async -> UserRoom {
        let randomRoom = await roomRepository.getRandomRoom()
        let randomShelf = await shelfRepository.getRandomShelf()
        
        return UserRoom(shelfType: randomShelf, roomType: randomRoom, name: Date().toReadableDate(), dateCreate: Date().getOffsetDate(offset: -30), plants: [:])
    }
    
    func getUserRoom(by id: UUID) {
        Task {
            userRooms[id] = await myRoomRepository.getUserRoomBy(by: id)
        }
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
    
    func updatePlantPosition(_ plant: Plant, newPosition: CGPoint) {
        guard let plant = userRooms[plant.rootRoomID]?.plants[plant.id] else { return }
        if plant.offsetX.isAlmostEqual(to: Double(newPosition.x)) && plant.offsetY.isAlmostEqual(to: Double(newPosition.y)) { return }
        let newPlant = plant.copy(offsetX: newPosition.x, offsetY: newPosition.y)
        Task {
            await plantRepository.updatePlant(newPlant)
        }
    }
    
    func saveNewPlant(_ newPlant: Plant) {
        Task {
            await plantRepository.saveNewPlant(newPlant)
            
            userRooms[newPlant.rootRoomID]?.plants[newPlant.id] = newPlant
            if newPlant.rootRoomID == currentRoom.id {
                currentRoom.plants[newPlant.id] = newPlant
            }
        }
    }
    
    func getRandomPlant(note: Note) async -> Plant {
        let randomPlant = await plantRepository.createRandomPlant(note: note, roomID: currentRoom.id)
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
            currentRoom.roomType = await roomRepository.getRandomRoom()
        }
    }
    
    func setRandomShelf() {
        Task {
            currentRoom.shelfType = await shelfRepository.getRandomShelf()
        }
        
    }
    
    func addRandomPlantToShelf() {
        Task {
            guard let roomId = userRooms.map { $0.key }.randomElement() else { return } //TMP
            let randomPlant = await plantRepository.createRandomPlant(note: getRandomNote(), roomID: roomId)
            saveNewPlant(randomPlant)
        }
    }
}
