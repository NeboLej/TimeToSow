//
//  ScreenBuilder.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI

enum ScreenType {
    case home
}

enum ComponentType {
    
}

final class ScreenBuilder {
    
    var appStore: AppStore
    
    init(appStore: AppStore) {
        self.appStore = appStore
    }
    
    @ViewBuilder
    func getScreen(type: ScreenType) -> some View {
        switch type {
        case .home:
            HomeScreen()
                .environment(\.appStore, appStore)
                .environment(\.screenBuilder, self)
        }
    }
    
    @ViewBuilder
    func getComponent(type: ComponentType) -> some View {
        
    }
}
