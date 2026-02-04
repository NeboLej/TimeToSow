//
//  ProgressScreenStore.swift
//  TimeToSow
//
//  Created by Nebo on 23.08.2025.
//

import SwiftUI

@Observable
final class ProgressScreenStore: FeatureStore {
    
    private var minutes: Int
    private var selectedTag: Tag
    private var startDate: Date
    private var progressScreenType: ProgressScreenStateType
    private var progressState: ProgressScreenState.State = .progress
    
    var state: ProgressScreenState {
        ProgressScreenState(state: progressState, minutes: minutes, startDate: startDate)
    }
    
    init(appStore: AppStore, state: ProgressScreenStateType) {
        self.minutes = state.minutes
        selectedTag = state.tag
        startDate = state.startDate
        progressScreenType = state
        
        super.init(appStore: appStore)
    }
    
    func send(_ action: ProgressScreenAction, animation: Animation? = .default) {
        if let animation {
            withAnimation(animation) {
                handle(action)
            }
        } else {
            handle(action)
        }
    }
    
    //MARK: - Private
    private func handle(_ action: ProgressScreenAction) {
        switch action {
        case .startProgress: break
        case .stopProgress: break
        case .finishProgress:
            getNewPlant()
        case .plantToShelf(let plant):
            appStore.send(.addNewPlant(plant))
        }
    }
    
    private func getNewPlant() {
        let note = Note(date: Date(), time: minutes, tag: selectedTag)
        Task {
            let plant = await appStore.getRandomPlant(note: note)
            progressState = .completed(plant)
        }
    }
}
