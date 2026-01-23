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
    let myRoomRepository: UserRoomRepositoryProtocol
    @ObservationIgnored
    let roomRepository: RoomRepositoryProtocol
    @ObservationIgnored
    let shelfRepository: ShelfRepositoryProtocol
    @ObservationIgnored
    let plantRepository: PlantRepositoryProtocol
    @ObservationIgnored
    let tagRepository: TagRepositoryProtocol
    
    var currentRoom: UserRoom = .empty
    var selectedPlant: Plant?
    var appCoordinator: AppCoordinator = AppCoordinator()
    var selectedTag: Tag?
    var simpleUserRooms: [SimpleUserRoom] = []
    var userRooms: [UUID: UserRoom] = [:]
    
    init(factory: RepositoryFactory) {
        self.myRoomRepository = factory.myRoomRepository
        self.plantRepository = factory.plantRepository
        self.tagRepository = factory.tagRepository
        self.roomRepository = factory.roomRepository
        self.shelfRepository = factory.shelfRepository
        
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
        case .moveDecor(decor: let decor, newPosition: let newPosition):
            updateDecorPosition(decor, newPosition: newPosition)
        case .changedRoomType(let newRoom):
            setNewRoom(newRoom)
        case .changedShelfType(let newShelf):
            setNewShelf(newShelf)
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
        case .selectTag(let tag):
            selectedTag = tag
        case .newTag(let tag):
            saveNewTag(tag)
        case .deleteTag(let tag):
            deleteTag(tag)
        }
    }
    
    let fff = FFff()
    func getData() {
        Task {
//            let newRoom = await createNewUserRoom()
//            await myRoomRepository.saveNewRoom(newRoom)
            await fff.ff()
            
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

import Supabase

class FFff {
    
    func ff() async {
        

        
        let client = SupabaseClient(
            supabaseURL: URL(string: "https://wdjemgjqjoevvylteewd.supabase.co")!,
            supabaseKey: "",
            options: SupabaseClientOptions(auth: SupabaseClientOptions.AuthOptions(emitLocalSessionAsInitialSession: true) )
        )
        
        
        let signedURL = try? await client
            .storage
            .from("plant")
            .createSignedURL(
                path: "pot59.png",
                expiresIn: 60 // секунды
            )

        print(signedURL?.path())
    }

}

