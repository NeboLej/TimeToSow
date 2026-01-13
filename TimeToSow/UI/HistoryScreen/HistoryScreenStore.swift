//
//  HistoryScreenStore.swift
//  TimeToSow
//
//  Created by Nebo on 07.01.2026.
//

import Foundation

@Observable
final class HistoryScreenStore: FeatureStore {
    
    var state: HistoryScreenState
    var selectedUserRoomId: UUID
    
    override init(appStore: AppStore) {
        selectedUserRoomId = appStore.currentRoom.id
        state = HistoryScreenState(selectedRoomId: appStore.currentRoom.id, appStore: appStore)
        
        super.init(appStore: appStore)
        observeAppState()
    }
    
    func send(action: HistoryScreenAction) {
        switch action {
        case .selectRoom(let id):
            selectedUserRoomId = id
            if let _ = appStore.userRooms[id] {
                selectedUserRoomId = id
                state = HistoryScreenState(selectedRoomId: selectedUserRoomId, appStore: appStore)
            } else {
                appStore.send(.getUserRoom(id: id))
            }
        }
    }
    
    //MARK: - Private
    private func observeAppState() {
        withObservationTracking {
            _ = appStore.userRooms
        } onChange: { [weak self] in
            Task { @MainActor in
                self?.rebuildState()
            }
        }
    }
    
    private func rebuildState() {
        if appStore.userRooms[selectedUserRoomId] != nil {
            state = HistoryScreenState(selectedRoomId: selectedUserRoomId, appStore: appStore)
        } else {
            selectedUserRoomId = appStore.currentRoom.id
        }
        observeAppState()
    }
    
}
