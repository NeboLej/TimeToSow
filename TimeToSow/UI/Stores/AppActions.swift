//
//  AppActions.swift
//  TimeToSow
//
//  Created by Nebo on 18.12.2025.
//

import Foundation

enum AppAction {
    case selectPlant(Plant?)
    case movePlant(plant: Plant, newPosition: CGPoint)
    case moveDecor(decor: Decor, newPosition: CGPoint)
    case changedRoomType(RoomType)
    case changedShelfType(ShelfType)
    case addRandomPlant
    case addRandomNote
    case addNewPlant(Plant)
    case addNewDecorToShelf(DecorType)
    case getUserRoom(id: UUID)
    case selectTag(Tag)
    case newTag(Tag)
    case deleteTag(Tag)
    case changeShelfVisibility(plant: Plant, isVisible: Bool)
    case reward(challenge: Challenge)
}

enum NavigateAction {
    case toDetailPlant(Plant)
    case toDebugScreen
}

enum BackgroundEventAction {
    case completeChallenges([Challenge])
    case challengesSeasonPrepared(ChallengeSeason)
}
