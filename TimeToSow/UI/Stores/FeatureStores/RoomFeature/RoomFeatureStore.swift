//
//  RoomFeatureStore.swift
//  TimeToSow
//
//  Created by Nebo on 18.12.2025.
//

import SwiftUI

@Observable
final class RoomFeatureStore: FeatureStore {
    
    var state: RoomViewState { RoomViewState(userRoom: room, selectedPlant: appStore.selectedPlant) }
    
    private var delegate: RoomFeatureDelegate
    private var selectedRoomId: UUID?
    private var room: UserRoom
    
    
    init(appStore: AppStore&RoomFeatureDelegate, selectedRoomId: UUID? = nil) {
        self.delegate = appStore

        var room: UserRoom
        if let selectedRoomId, let currentRoom = appStore.userRooms[selectedRoomId] {
            room = currentRoom
        } else {
            room = appStore.currentRoom
        }
        
        self.room = room
        
        super.init(appStore: appStore)
    }
    
    func send(_ action: RoomFeatureAction, animation: Animation? = .default) {
        if let animation {
            withAnimation(animation) {
                delegate.send(action)
            }
        } else {
            delegate.send(action)
        }
    }
}
