//
//  ScreenBuilder.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI

enum ScreenType: Identifiable, Hashable {
    
    case home, editRoom, progress(ProgressScreenStateType), plantDetails(Plant), debugScreen, history, tags, challenge, box
    
    var id: String {
        switch self {
        case .home: "home"
        case .editRoom: "editRoom"
        case .progress: "progress"
        case .plantDetails(let plant): "plantDetails - \(plant.id)"
        case .debugScreen: "debugScreen"
        case .history: "history"
        case .tags: "tags"
        case .challenge: "challenge"
        case .box: "box"
        }
    }
}

enum ComponentType {
    case roomView(id: UUID? = nil)
    case challengeCompleteView
}

final class ScreenBuilder {
    
    private let appStore: AppStore
    private let repositories: RepositoryFactoryProtocol
    
    init(appStore: AppStore, repositoryFactory: RepositoryFactoryProtocol) {
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
        case .progress(let state):
            ProgressScreen(store: ProgressScreenStore(appStore: appStore, state: state))
        case .plantDetails(let plant):
            PlantDetailScreen(store: PlantDetailScreenStore(appStore: appStore, plant: plant))
                .ignoresSafeArea()
        case .debugScreen:
            DebugScreenView()
        case .history:
            HistoryScreen(store: HistoryScreenStore(appStore: appStore), screenBuilder: self)
        case .tags:
            TagsScreen(store: TagsScreenStore(appStore: appStore, tagRepository: repositories.tagRepository))
        case .challenge:
            ChallengeScreen(store: ChallengeStore(appStore: appStore, challengeService: appStore.challengeService))
        case .box:
            BoxScreen(store: BoxScreenStore(appStore: appStore, decorRepository: repositories.decorRepository))
        }
    }
    
    @ViewBuilder
    func getComponent(type: ComponentType) -> some View {
        switch type {
        case .roomView(let id):
            RoomView(store: RoomFeatureStore(appStore: appStore, selectedRoomId: id))
        case .challengeCompleteView:
            ChallengeCompleteView(store: RewardChallengeStore(appStore: appStore))
        }
    }
}
