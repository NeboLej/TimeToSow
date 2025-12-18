//
//  ScreenBuilder.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI

enum ScreenType {
    case home, editRoom, progress(Int)
}

enum ComponentType {
    case roomView
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
            HomeScreen(store: HomeScreenStore(appStore: appStore))
                .environment(\.appStore, appStore)
                .environment(\.screenBuilder, self)
        case .editRoom:
            EditRoomScreen()
                .environment(\.appStore, appStore)
        case .progress(let minutes):
            ProgressScreen(minutes: minutes)
                .environment(\.appStore, appStore)
        }
    }
    
    @ViewBuilder
    func getComponent(type: ComponentType) -> some View {
        switch type {
        case .roomView:
            RoomView(store: RoomFeatureStore(appStore: appStore))
        }
    }
}
