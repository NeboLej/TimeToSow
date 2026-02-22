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
    let challengeService: ChallengeServiceProtocol
    @ObservationIgnored
    let taskService: TaskServiceProtocol
    
    var currentRoom: UserRoom = .empty
    var selectedPlant: Plant?
    var appCoordinator: AppCoordinator = AppCoordinator()
    var selectedTag: Tag?
    var simpleUserRooms: [SimpleUserRoom] = []
    var userRooms: [UUID: UserRoom] = [:]
    var challegeSeason: ChallengeSeason?
    var completedChallenges: [Challenge] = []
    
    init(factory: RepositoryFactoryProtocol) {
        self.myRoomRepository = factory.myRoomRepository
        self.plantRepository = factory.plantRepository
        self.tagRepository = factory.tagRepository
        self.roomRepository = factory.roomRepository
        self.shelfRepository = factory.shelfRepository
        self.challengeRepository = factory.challengeRepository
        self.challengeService = factory.challengeService
        self.decorRepository = factory.decorRepository
        self.taskService = factory.taskService
        
        factory.remoteRepository.setDelegate(self)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.getData()
        }
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
            appCoordinator.present(to: .plantDetails(plant), modal: true)
        case .toDebugScreen:
            appCoordinator.activeSheet = .debugScreen
        }
    }
    
    func send(_ action: AppAction) {
        switch action {
        case .startNewTask(minutes: let minutes):
            startNewTask(minutes: minutes)
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
        case .addNewPlant(let newPlant):
            userRooms[newPlant.rootRoomID]?.plants[newPlant.id] = newPlant
            if newPlant.rootRoomID == currentRoom.id {
                currentRoom.plants[newPlant.id] = newPlant
            }
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
        case .reward(challenge: let challenge, let isUse):
            saveCompleteChallenge(challenge)
            if let decor = challenge.rewardDecor {
                saveNewDecorType(decor, toShelf: isUse)
            }
        case .deletePlant(plant: let plant):
            deletePlant(plant)
        case .deleteNote(note: let note, let roomId):
            deleteNote(note, roomId: roomId)
        }
    }
    
    func getData() {
        Task {
            let continueTask = await taskService.getTask()

            let lastRoom = await myRoomRepository.getCurrentRoom()
            let room: UserRoom
            
            if let lastRoom, lastRoom.dateCreate.isCurrentMonth() {
                room = lastRoom
            } else {
                room = await createNewUserRoom()
                await myRoomRepository.saveNewRoom(room)
            }
            simpleUserRooms = await myRoomRepository.getAllSimpleUserRooms()
            
            if let continueTask {
                selectedTag = continueTask.tag
                self.continueTask(task: continueTask)
            } else {
                selectedTag = await tagRepository.getRandomTag()
            }
            
            await MainActor.run {
                currentRoom = room
                userRooms[currentRoom.id] = currentRoom
            }
        }
    }
    
    func startNewTask(minutes: Int) {
        guard let selectedTag else { return }
        let task = TaskModel(id: UUID(), startTime: Date(), time: minutes, tag: selectedTag, plant: selectedPlant)
        taskService.newTask(task)
        selectedPlant = nil
        appCoordinator.navigate(to: ScreenType.progress(task))
    }
    
    func continueTask(task: TaskModel) {
        appCoordinator.navigate(to: ScreenType.progress(task))
    }
}
