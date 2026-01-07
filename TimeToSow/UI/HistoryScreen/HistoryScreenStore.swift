//
//  HistoryScreenStore.swift
//  TimeToSow
//
//  Created by Nebo on 07.01.2026.
//

import Foundation

class HistoryScreenStore: FeatureStore {
    
    var state: HistoryScreenState
    
    override init(appStore: AppStore) {
        state = HistoryScreenState(appStore: appStore)
        super.init(appStore: appStore)
    }
    
    func send(action: HistoryScreenAction) {
        
    }
}
