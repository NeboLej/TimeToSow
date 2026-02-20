//
//  ProgressScreenStore.swift
//  TimeToSow
//
//  Created by Nebo on 23.08.2025.
//

import SwiftUI

@Observable
final class ProgressScreenStore: FeatureStore {
    
    private let minutes: Int
    private let selectedTag: Tag
    private let startDate: Date
    
    private var rewardPlant: Plant?
    private let upgradedPlant: Plant?
    private let taskService: TaskServiceProtocol
    private let task: TaskModel
    
    private var progressState: ProgressScreenState.State = .progress
    
    var state: ProgressScreenState {
        ProgressScreenState(state: progressState, minutes: minutes, startDate: startDate, upgradedPlant: upgradedPlant)
    }
    
    init(appStore: AppStore, taskService: TaskServiceProtocol, task: TaskModel) {
        self.minutes = task.time
        selectedTag = task.tag
        startDate = task.startTime//.getOffsetDate(-50, component: .second)
        rewardPlant = task.rewardPlant
        upgradedPlant = task.plant
        self.taskService = taskService
        self.task = task
        
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
        case .stopProgress:
            taskService.stopTask()
        case .finishProgress:
            if let rewardPlant {
                progressState = .completed(rewardPlant)
            } else {
                getNewPlant()
            }
        case .plantToShelf:
            if let upgradedPlant, let rewardPlant {
                appStore.combinePlants(main: upgradedPlant, donor: rewardPlant)
            }
            taskService.taskCompleted(task)
        }
    }
    
    private func getNewPlant() {
        let note = Note(date: Date(), time: minutes, tag: selectedTag)
        Task {
            var plant: Plant
            if let upgradedPlant {
                plant = await appStore.getUpgradedPlant(plant: upgradedPlant, note: note)
            } else {
                plant = await appStore.getRandomPlant(note: note)
            }
            rewardPlant = plant
            progressState = .completed(plant)
            appStore.send(.addNewPlant(plant))
            taskService.saveRewardForTheTask(task, reward: plant)
        }
    }
}
