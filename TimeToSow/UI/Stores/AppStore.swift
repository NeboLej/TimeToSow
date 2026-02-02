//
//  AppStore.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI
import GRDB

@Observable
final class AppStore: BackgroundEventDeleagate {
    
    @ObservationIgnored
    let myRoomRepository: UserRoomRepositoryProtocol
    @ObservationIgnored
    let roomRepository: RoomRepositoryProtocol
    @ObservationIgnored
    let shelfRepository: ShelfRepositoryProtocol
    @ObservationIgnored
    let plantRepository: PlantRepositoryProtocol
    @ObservationIgnored
    let tagRepository: TagRepositoryProtocol
    @ObservationIgnored
    let challengeRepository: ChallengeRepositoryProtocol
    @ObservationIgnored
    let decorRepository: DecorRepositoryProtocol
    @ObservationIgnored
    var challengeService: ChallengeService
    
    var currentRoom: UserRoom = .empty
    var selectedPlant: Plant?
    var appCoordinator: AppCoordinator = AppCoordinator()
    var selectedTag: Tag?
    var simpleUserRooms: [SimpleUserRoom] = []
    var userRooms: [UUID: UserRoom] = [:]
    var challegeSeason: ChallengeSeason?
    var completedChallenges: [Challenge] = []
    
    init(factory: RepositoryFactory) {
        self.myRoomRepository = factory.myRoomRepository
        self.plantRepository = factory.plantRepository
        self.tagRepository = factory.tagRepository
        self.roomRepository = factory.roomRepository
        self.shelfRepository = factory.shelfRepository
        self.challengeRepository = factory.challengeRepository
        self.challengeService = factory.challengeService
        self.decorRepository = factory.decorRepository
        
        factory.remoteRepository.delegate = self
        
        getData()
    }
    
    func send(_ action: BackgroundEventAction) {
        switch action {
        case .completeChallenges(let challenges):
            completedChallenges = challenges
        case .challengesSeasonPrepared(let challengeSeason):
            self.challegeSeason = challengeSeason
            challengeService.startObservation(appStore: self)
        }
    }
    
    func send(_ action: NavigateAction) {
        switch action {
        case .toDetailPlant(let plant):
            guard let plant = userRooms[plant.rootRoomID]?.plants[plant.id] else { return }
            appCoordinator.navigate(to: .plantDetails(plant), modal: true)
        case .toDebugScreen:
            appCoordinator.activeSheet = .debugScreen
        }
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
        case .moveDecor(decor: let decor, newPosition: let newPosition):
            updateDecorPosition(decor, newPosition: newPosition)
        case .changedRoomType(let newRoom):
            setNewRoom(newRoom)
        case .changedShelfType(let newShelf):
            setNewShelf(newShelf)
        case .addRandomPlant:
            addRandomPlantToShelf()
        case .addRandomNote:
            guard let selectedPlant else { return }
            let newNotes = getRandomNote()
            var notes = selectedPlant.notes
            notes.append(newNotes)
            let newPlant = selectedPlant.copy(notes: notes)
            self.selectedPlant = newPlant
            currentRoom.plants[selectedPlant.id] = newPlant
        case .addNewPlant(let plant):
            saveNewPlant(plant)
        case .addNewDecorToShelf(let decorType):
            newDecorToShelf(decorType)
        case .getUserRoom(let id):
            getUserRoom(by: id)
        case .selectTag(let tag):
            selectedTag = tag
        case .newTag(let tag):
            saveNewTag(tag)
        case .deleteTag(let tag):
            deleteTag(tag)
        case .changeShelfVisibility(plant: let plant, isVisible: let isVisible):
            updatePlantVisibleInShelf(plant, isVisible: isVisible)
            selectedPlant = nil
        case .reward(challenge: let challenge):
            saveCompleteChallenge(challenge)
            if let decor = challenge.rewardDecor {
                saveNewDecorType(decor)
            }
        }
    }
    
    func getData() {
        Task {
            selectedTag = await tagRepository.getRandomTag()
            let lastRoom = await myRoomRepository.getCurrentRoom()
            if let lastRoom, lastRoom.dateCreate.isCurrentMonth() {
                currentRoom = lastRoom
            } else {
                currentRoom = await createNewUserRoom()
                await myRoomRepository.saveNewRoom(currentRoom)
            }
            userRooms[currentRoom.id] = currentRoom
            simpleUserRooms = await myRoomRepository.getAllSimpleUserRooms()
        }
    }
}
