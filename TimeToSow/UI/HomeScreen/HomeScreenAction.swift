//
//  HomeScreenAction.swift
//  TimeToSow
//
//  Created by Nebo on 19.12.2025.
//

import Foundation

enum HomeScreenAction {
    case loadData
    case changedRoomType
    case changedShelfType
    case addRandomPlant
    case addRandomNote
    case toDebugScreen
    case toProgressScreen(time: Int)
    case toHistoryScreen
}

protocol HomeScreenDelegate: AnyObject {
    func send(action: HomeScreenAction)
}

extension AppStore: HomeScreenDelegate {
    func send(action: HomeScreenAction) {
        switch action {
        case .loadData:
            getData()
        case .changedRoomType:
            send(.changedRoomType)
        case .changedShelfType:
            send(.changedShelfType)
        case .addRandomPlant:
            send(.addRandomPlant)
        case .addRandomNote:
            send(.addRandomNote)
        case .toDebugScreen:
            send(.toDebugScreen)
        case .toProgressScreen(let time):
            appCoordinator.navigate(to: .progress(time), modal: false)
        case .toHistoryScreen:
            appCoordinator.path.append(ScreenType.history)
        }
    }
}
