//
//  EditRoomStore.swift
//  TimeToSow
//
//  Created by Nebo on 17.01.2026.
//

import Foundation
import SwiftUI

@Observable
final class EditRoomStore: FeatureStore {
    
    var state: EditRoomState
    var selectedRoom: RoomType
    var selectedShelf: ShelfType
    var allRooms: [RoomType] = []
    var allShelfs: [ShelfType] = []
    
    init(appStore: AppStore, roomRepository: RoomRepositoryProtocol, shelfRepository: ShelfRepositoryProtocol) {
        selectedRoom = appStore.currentRoom.roomType
        selectedShelf = appStore.currentRoom.shelfType
        state = EditRoomState(selectedRoom: appStore.currentRoom.roomType,
                              selectedShelf: appStore.currentRoom.shelfType,
                              allRooms: [], allShelfs: [])
        
        super.init(appStore: appStore)
        
        getData(roomRepository: roomRepository, shelfRepository: shelfRepository)
//        observeAppState()
    }
    
    func send(_ action: EditRoomAction, animation: Animation? = .default) {
        withAnimation(animation) {
            switch action {
            case .save:
                if selectedRoom != appStore.currentRoom.roomType {
                    appStore.send(.changedRoomType(selectedRoom))
                }
                if selectedShelf != appStore.currentRoom.shelfType {
                    appStore.send(.changedShelfType(selectedShelf))
                }
            case .selectRoom(let roomType):
                selectedRoom = roomType
                rebuildState()
            case .selectShelf(let shelfType):
                selectedShelf = shelfType
                rebuildState()
            }
        }
    }
    
    func getData(roomRepository: RoomRepositoryProtocol, shelfRepository: ShelfRepositoryProtocol) {
        Task {
            allRooms = await roomRepository.getAllRooms()
            allShelfs = await shelfRepository.getAllShelfs()
            
            rebuildState()
        }
    }
    
    
//    //MARK: - Private
//    private func observeAppState() {
//        withObservationTracking {
//            _ = appStore.currentRoom
//        } onChange: { [weak self] in
//            self?.rebuildState()
//        }
//    }
//    
    private func rebuildState() {
        state = EditRoomState(selectedRoom: selectedRoom, selectedShelf: selectedShelf, allRooms: allRooms, allShelfs: allShelfs)
        
//        observeAppState()
    }
}
