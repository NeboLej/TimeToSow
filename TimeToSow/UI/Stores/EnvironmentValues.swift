//
//  EnvironmentValues.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation
import SwiftUI

struct ScreenBuilderKey: EnvironmentKey {
    static var defaultValue = ScreenBuilder(appStore: AppStore(shelfRepository: ShelfRepository()))
}

struct AppStoreKey: EnvironmentKey {
    static var defaultValue = AppStore(shelfRepository: ShelfRepository())
}

extension EnvironmentValues {
    var screenBuilder: ScreenBuilder {
        get { self[ScreenBuilderKey.self] }
        set { self[ScreenBuilderKey.self] = newValue }
    }
    
    var appStore: AppStore {
        get { self[AppStoreKey.self] }
        set { self[AppStoreKey.self] = newValue }
    }
}
