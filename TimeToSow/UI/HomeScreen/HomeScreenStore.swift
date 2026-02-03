//
//  HomeScreenFeatureStore.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import SwiftUI

@Observable
final class HomeScreenStore: FeatureStore {
    
    var state: HomeScreenState { HomeScreenState(appStore: appStore) }
    
    private var delegate: HomeScreenDelegate
    
    init(appStore: AppStore&HomeScreenDelegate) {
        delegate = appStore
        
        super.init(appStore: appStore)
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
}
