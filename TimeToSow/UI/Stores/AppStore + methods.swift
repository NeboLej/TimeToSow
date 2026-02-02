//
//  AppStore + methods.swift
//  TimeToSow
//
//  Created by Nebo on 17.01.2026.
//

import Foundation

extension AppStore {
    
    //MARK: - User Room
    func createNewUserRoom() async -> UserRoom {
        let randomRoom = await roomRepository.getRandomRoom()
        let randomShelf = await shelfRepository.getRandomShelf()
        let dateCreate = Date()//.getOffsetDate(days: -32)
        
        return UserRoom(shelfType: randomShelf, roomType: randomRoom, name: dateCreate.toMonthYearDate(), dateCreate: dateCreate, plants: [:], decor: [:])
    }
    
    func getUserRoom(by id: UUID) {
        Task {
            userRooms[id] = await myRoomRepository.getUserRoomBy(by: id)
        }
    }
    
    
    //MARK: - Shelf
    func setNewShelf(_ shelf: ShelfType) {
        Task {
            currentRoom.shelfType = shelf
            await myRoomRepository.updateRoom(currentRoom)
        }
    }
    
    //MARK: - Plant
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
    
    func updatePlantPosition(_ plant: Plant, newPosition: CGPoint) {
        guard let plant = userRooms[plant.rootRoomID]?.plants[plant.id] else { return }
        if plant.offsetX.isAlmostEqual(to: Double(newPosition.x)) && plant.offsetY.isAlmostEqual(to: Double(newPosition.y)) { return }
        let newPlant = plant.copy(offsetX: newPosition.x, offsetY: newPosition.y)
        Task {
            await plantRepository.updatePlant(newPlant)
        }
        userRooms[plant.rootRoomID]?.plants[plant.id] = newPlant
    }
    
    func updatePlantVisibleInShelf(_ plant: Plant, isVisible: Bool) {
        guard let plant = userRooms[plant.rootRoomID]?.plants[plant.id] else { return }
        let newPlant = plant.copy(isVisible: isVisible)
        Task {
            await plantRepository.updatePlant(newPlant)
        }
        userRooms[plant.rootRoomID]?.plants[plant.id] = newPlant
    }
    
    //test
    func addRandomPlantToShelf() {
        Task {
            guard let roomId = userRooms.map({ $0.key }).randomElement() else { return } //TMP
            let randomPlant = await plantRepository.createRandomPlant(note: getRandomNote(), roomID: roomId)
            saveNewPlant(randomPlant)
        }
    }
    
    //MARK: - Note
    func getRandomNote() -> Note {
        guard let selectedTag else { fatalError() }
        return Note(date: Date().getOffsetDate((-5...0).randomElement()!),
             time: (5...240).randomElement()!,
             tag: selectedTag)
    }
    
    //MARK: - Room
    func setNewRoom(_ room: RoomType) {
        Task {
            currentRoom.roomType = room
            await myRoomRepository.updateRoom(currentRoom)
        }
    }
    
    //MARK: - Tag
    func saveNewTag(_ tag: Tag) {
        Task {
            await tagRepository.saveNewTag(tag)
        }
    }
    
    func deleteTag(_ tag: Tag) {
        Task {
            await tagRepository.deleteTag(tag)
            if selectedTag == tag {
                selectedTag = await tagRepository.getRandomTag()
            }
        }
    }
    
    //MARK: - Decor
    func updateDecorPosition(_ decor: Decor, newPosition: CGPoint) {
        guard let decor = currentRoom.decor[decor.id] else { return } //.first { $0.id == decor.id } else { return }
//        if decor.positon.x.isAlmostEqual(to: newPosition.x) && decor.positon.y.isAlmostEqual(to: newPosition.y) { return }
        let newDecor = decor.copy(offsetX: newPosition.x, offsetY: newPosition.y)
//        Task {
//            await plantRepository.updatePlant(newPlant)
//        }
        currentRoom.decor[decor.id] = newDecor
    }
    
    func saveNewDecorType(_ decorModel: DecorModel) {
        Task {
            let decorType = DecorType(from: decorModel)
            await decorRepository.saveNewDecorTypes([decorType])
        }
    }
    
    func newDecorToShelf(_ decorType: DecorType) {
        let offsetY = Double((10...250).randomElement()!)
        let offsetX = Double((10...350).randomElement()!)
        let decor = Decor(decorType: decorType, rootRoomID: currentRoom.id, offsetY: offsetY, offsetX: offsetX)
        currentRoom.decor[decor.id] = decor
        userRooms[currentRoom.id]?.decor[decor.id] = decor
        Task {
            await decorRepository.saveNewDecor(decor)
        }
    }
    
    //MARK: - Challenge
    func saveCompleteChallenge(_ challenge: Challenge) {
        completedChallenges.removeAll(where: { $0.id == challenge.id })
        Task {
            guard let challegeSeason else { return }
            let newCompletedChallenge = CompletedChallenge(id: challenge.id, seasonID: challegeSeason.stableId, date: Date())
            await challengeRepository.saveCompletedChallenge(newCompletedChallenge)
        }
    }
}
