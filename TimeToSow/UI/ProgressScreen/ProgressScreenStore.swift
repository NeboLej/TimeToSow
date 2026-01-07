//
//  ProgressScreenStore.swift
//  TimeToSow
//
//  Created by Nebo on 23.08.2025.
//

import SwiftUI

@Observable
class ProgressScreenStore: FeatureStore, TimerListenerProtocol {

    enum State {
        case progress, completed
    }
    
    var state: State = .progress
    var progress: Float = 0.0
    var minutes: Int
    var timerVM: TimerVM!
    var newPlant: Plant? = nil
    var selectedTag: Tag
    var startDate: Date
    
    private var delegate: ProgressScreenDelegate

    
    init(appStore: AppStore&ProgressScreenDelegate, minutes: Int) {
        delegate = appStore
        self.minutes = minutes
        selectedTag = appStore.selectedTag!
        startDate = Date()
        super.init(appStore: appStore)
        
        self.timerVM = TimerVM(minutes: Float(minutes), startSecond: 0, parent: self)
        
        observeAppState()
    }
    
    func getNewPlant() {
        let note = Note(date: Date(), time: minutes, tag: selectedTag)
        newPlant = appStore.getRandomPlant(note: note)
    }
    
    func newPlantToShelf() {
        let plant = newPlant ?? appStore.getRandomPlant(note: appStore.getRandomNote())
        send(.finishProgress(plant: plant))
    }
    
    func calcProgress(newValue: Float) {
        progress = 1.0 - ((100.0 / (Float(minutes) * 60)) * newValue)/100.0
    }
    
    func send(_ action: ProgressScreenAction, animation: Animation? = .default) {
        if let animation {
            withAnimation(animation) {
                delegate.send(action: action)
            }
        } else {
            delegate.send(action: action)
        }
    }
    
    //MARK: - Private
    private func observeAppState() {
        withObservationTracking {
            _ = appStore.currentRoom
            _ = appStore.selectedTag
        } onChange: { [weak self] in
            self?.rebuildState()
        }
    }
    
    private func rebuildState() {
        selectedTag = appStore.selectedTag!
        observeAppState()
    }
    
    //MARK: - TimerListenerProtocol
    func timeRuns(seconds: Float) {
        calcProgress(newValue: seconds)
    }
    
    func timeFinish(on: Bool) {
        if on {
            getNewPlant()
            state = .completed
        } else {
            state = .progress
        }
    }
}
