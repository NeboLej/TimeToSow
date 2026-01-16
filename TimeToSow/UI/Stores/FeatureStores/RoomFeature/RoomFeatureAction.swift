//
//  RoomFeatureAction.swift
//  TimeToSow
//
//  Created by Nebo on 18.12.2025.
//

import Foundation

enum RoomFeatureAction {
    case selectPlant(Plant?)
    case roomTapped
    case startMovePlant
    case movePlant(Plant, CGPoint)
    case detailPlant(Plant)
}

protocol RoomFeatureDelegate: AnyObject {
    func send(_ action: RoomFeatureAction)
}

extension AppStore: RoomFeatureDelegate {
    func send(_ action: RoomFeatureAction) {
        switch action {
        case .selectPlant(let plant):
            send(AppAction.selectPlant(plant == selectedPlant ? nil : plant))
        case .roomTapped:
            send(AppAction.selectPlant(nil))
        case .startMovePlant:
            send(AppAction.selectPlant(nil))
        case .movePlant(let plant, let position):
            send(AppAction.movePlant(plant: plant, newPosition: position))
        case .detailPlant(let plant):
            send(AppAction.detailPlant(plant))
        }
    }
}
