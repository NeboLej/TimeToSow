//
//  HomeScreenFeatureStore.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import SwiftUI

@Observable
final class HomeScreenStore: FeatureStore {
    
    var state: HomeScreenState
    private var delegate: HomeScreenDelegate
    
    init(appStore: AppStore&HomeScreenDelegate) {
        state = HomeScreenState(appStore: appStore)
        delegate = appStore
        
        super.init(appStore: appStore)
        observeAppState()
    }
    
    func send(_ action: HomeScreenAction, animation: Animation? = .default) {
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
            _ = appStore.selectedPlant
            _ = appStore.selectedTag
        } onChange: { [weak self] in
            self?.rebuildState()
        }
    }
    
    private func rebuildState() {
        state = HomeScreenState(appStore: appStore)
        
        observeAppState()
    }
}
