//
//  ProgressScreenAction.swift
//  TimeToSow
//
//  Created by Nebo on 06.01.2026.
//

import Foundation

enum ProgressScreenAction {
    case startProgress
    case stopProgress
    case finishProgress(plant: Plant)
}

protocol ProgressScreenDelegate {
    func send(action: ProgressScreenAction)
}

extension AppStore: ProgressScreenDelegate {
    
    func send(action: ProgressScreenAction) {
        switch action {
        case .startProgress: break
        case .stopProgress: break
        case .finishProgress(let plant):
            send(.addNewPlant(plant))
        }
    }
}
