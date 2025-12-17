//
//  FeatureStore.swift
//  TimeToSow
//
//  Created by Nebo on 18.12.2025.
//

import Foundation
import Combine

class FeatureStore {
    
    let cancellables: Set<AnyCancellable>
    let appStore: AppStore
    
    init(cancellables: Set<AnyCancellable> = Set<AnyCancellable>(), appStore: AppStore) {
        self.cancellables = cancellables
        self.appStore = appStore
    }
}
