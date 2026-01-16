//
//  ScreenBuilder.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI

enum ScreenType: Identifiable, Hashable {
    
    case home, editRoom, progress(Int), plantDetails(Plant), debugScreen, history
    
    var id: String {
        switch self {
        case .home: "home"
        case .editRoom: "editRoom"
        case .progress: "progress"
        case .plantDetails(let plant): "plantDetails - \(plant.id)"
        case .debugScreen: "debugScreen"
        case .history: "history"
        }
    }
}

enum ComponentType {
    case roomView(id: UUID? = nil)
}

final class ScreenBuilder {
    
    private let appStore: AppStore
    private let repositories: RepositoryFactory
    
    init(appStore: AppStore, repositoryFactory: RepositoryFactory) {
        self.appStore = appStore
        self.repositories = repositoryFactory
    }
    
    @ViewBuilder
    func getScreen(type: ScreenType) -> some View {
        switch type {
        case .home:
            HomeScreen(store: HomeScreenStore(appStore: appStore), screenBuilder: self)
        case .editRoom:
            EditRoomScreen(store: EditRoomStore(appStore: appStore, roomRepository: repositories.roomRepository, shelfRepository: repositories.shelfRepository))
        case .progress(let minutes):
            ProgressScreen(store: ProgressScreenStore(appStore: appStore, minutes: minutes))
        case .plantDetails(let plant):
            PlantDetailScreen(plant: plant)
                .ignoresSafeArea()
        case .debugScreen:
            DebugScreenView()
        case .history:
            HistoryScreen(store: HistoryScreenStore(appStore: appStore), screenBuilder: self)
        }
    }
    
    @ViewBuilder
    func getComponent(type: ComponentType) -> some View {
        switch type {
        case .roomView(let id):
            RoomView(store: RoomFeatureStore(appStore: appStore, selectedRoomId: id))
        }
    }
}
