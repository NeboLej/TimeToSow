//
//  HomeScreenAction.swift
//  TimeToSow
//
//  Created by Nebo on 19.12.2025.
//

import Foundation

enum HomeScreenAction {
    case changedRoomType
    case changedShelfType
    case addRandomPlant
    case addRandomNote
}

protocol HomeScreenDelegate: AnyObject {
    func send(action: HomeScreenAction)
}

extension AppStore: HomeScreenDelegate {
    func send(action: HomeScreenAction) {
        switch action {
        case .changedRoomType:
            send(.changedRoomType)
        case .changedShelfType:
            send(.changedShelfType)
        case .addRandomPlant:
            send(.addRandomPlant)
        case .addRandomNote:
            send(.addRandomNote)
        }
    }
}
