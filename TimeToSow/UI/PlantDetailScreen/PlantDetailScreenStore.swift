//
//  PlantDetailScreenStore.swift
//  TimeToSow
//
//  Created by Nebo on 26.01.2026.
//

import SwiftUI

@Observable
final class PlantDetailScreenStore: FeatureStore {
    
    private var plant: Plant
    var state: PlantDetailScreenState
    
    init(appStore: AppStore, plant: Plant) {
        self.plant = plant
        self.state = PlantDetailScreenState(plant: plant)
        super.init(appStore: appStore)
    }
    
    func send(_ action: PlantDetailScreenAction, animation: Animation? = .default) {
        if let animation {
            withAnimation(animation) {
                appStoreSend(action)
            }
        } else {
            appStoreSend(action)
        }
    }
    
    private func appStoreSend(_ action: PlantDetailScreenAction) {
        switch action {
        case .changeShelfVisibility:
            appStore.send(AppAction.changeShelfVisibility(plant: plant, isVisible: !plant.isOnShelf))
        case .deletePlant:
            appStore.send(.deletePlant(plant: plant))
        case .deleteNote(let note):
            plant = plant.copy(notes: plant.notes.filter { $0.id != note.id })
            self.state = PlantDetailScreenState(plant: plant)
            appStore.send(.deleteNote(note: note, roomId: plant.rootRoomID))
        }
    }
}
