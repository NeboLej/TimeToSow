//
//  RoomFeatureStore.swift
//  TimeToSow
//
//  Created by Nebo on 18.12.2025.
//

import SwiftUI

@Observable
final class RoomFeatureStore: FeatureStore {
    var state: RoomViewState
    
    private var delegate: RoomFeatureDelegate?
    private var selectedRoomId: UUID?
    var room: UserRoom
    
    init(appStore: AppStore&RoomFeatureDelegate, selectedRoomId: UUID? = nil) {
        self.delegate = appStore

        var room: UserRoom
        if let selectedRoomId, let currentRoom = appStore.userRooms[selectedRoomId] {
            room = currentRoom
        } else {
            room = appStore.currentRoom
        }
        
        state = RoomViewState(roomType: room.roomType,
                              shelfType: room.shelfType,
                              plants: room.plants.values.map { PlantViewState(plant: $0, isSelected: $0 == appStore.selectedPlant) })
        self.room = room
        
        super.init(appStore: appStore)
        observeAppState()
    }
    
    func send(_ acion: RoomFeatureAction, animation: Animation? = .default) {
        if let animation {
            withAnimation(animation) {
                delegate?.send(action: acion)
            }
        } else {
            delegate?.send(action: acion)
        }
    }
    
    //MARK: - Private
    private func observeAppState() {
        withObservationTracking {
            _ = appStore.currentRoom
            _ = appStore.selectedPlant
        } onChange: { [weak self] in
            self?.rebuildState()
        }
    }
    
    private func rebuildState() {
        state = RoomViewState(roomType: room.roomType,
                              shelfType: room.shelfType,
                              plants: room.plants.values.map { PlantViewState(plant: $0, isSelected: $0 == appStore.selectedPlant) })
        
        observeAppState()
    }
}
