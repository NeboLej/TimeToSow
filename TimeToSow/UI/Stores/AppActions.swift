//
//  AppActions.swift
//  TimeToSow
//
//  Created by Nebo on 18.12.2025.
//

import Foundation

enum AppAction {
    case startNewTask(minutes: Int)
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
    case reward(challenge: Challenge, isUse: Bool)
    case deletePlant(plant: Plant)
    case deleteNote(note: Note, roomId: UUID)
}

enum NavigateAction {
    case toDetailPlant(Plant)
    case toDebugScreen
}

enum BackgroundEventAction {
    case completeChallenges([Challenge])
    case challengesSeasonPrepared(ChallengeSeason)
}
