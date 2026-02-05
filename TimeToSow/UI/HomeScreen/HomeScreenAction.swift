//
//  HomeScreenAction.swift
//  TimeToSow
//
//  Created by Nebo on 19.12.2025.
//

import Foundation

enum HomeScreenAction {
    case addRandomPlant
    case addRandomNote
    case toDebugScreen
    case toProgressScreen(time: Int)
    case toHistoryScreen
    case toEditRoomScreen
    case toTagsScreen
    case toChallengeScreen
    case toBoxScreen
}

protocol HomeScreenDelegate: AnyObject {
    func send(action: HomeScreenAction)
}

extension AppStore: HomeScreenDelegate {
    func send(action: HomeScreenAction) {
        switch action {
        case .addRandomPlant:
            send(.addRandomPlant)
        case .addRandomNote:
            send(.addRandomNote)
        case .toDebugScreen:
            send(.toDebugScreen)
        case .toProgressScreen(let time):
            send(.startNewTask(minutes: time))
        case .toHistoryScreen:
            appCoordinator.path.append(ScreenType.history)
        case .toEditRoomScreen:
            appCoordinator.present(to: .editRoom, modal: true)
        case .toTagsScreen:
            appCoordinator.present(to: .tags, modal: true)
        case .toChallengeScreen:
            appCoordinator.navigate(to: ScreenType.challenge)
        case .toBoxScreen:
            appCoordinator.present(to: .box, modal: true)
        }
    }
}
