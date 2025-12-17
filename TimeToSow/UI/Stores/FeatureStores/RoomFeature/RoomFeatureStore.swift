//
//  RoomFeatureStore.swift
//  TimeToSow
//
//  Created by Nebo on 18.12.2025.
//

import Foundation

@Observable
final class RoomFeatureStore: FeatureStore {
    var state: RoomViewState
    
    private var delegate: RoomFeatureDelegate
    
    init(appStore: AppStore&RoomFeatureDelegate) {
        self.delegate = appStore
        
        let room = appStore.currentRoom
        state = RoomViewState(roomType: room.roomType,
                              shelfType: room.shelfType,
                              plants: room.plants.values.map { PlantViewState(plant: $0, isSelected: $0 == appStore.selectedPlant) })
        
        super.init(appStore: appStore)
        
        observeAppState()
    }
    
    
    private func observeAppState() {
        withObservationTracking {
            _ = appStore.currentRoom
            _ = appStore.selectedPlant
        } onChange: { [weak self] in
            self?.rebuildState()
        }
    }
    
    private func rebuildState() {
        let room = appStore.currentRoom
        state = RoomViewState(roomType: room.roomType,
                              shelfType: room.shelfType,
                              plants: room.plants.values.map { PlantViewState(plant: $0, isSelected: $0 == appStore.selectedPlant) })
        
        observeAppState()
    }
    
    func send(_ acion: RoomFeatureAction) {
        delegate.send(action: acion)
    }
}
