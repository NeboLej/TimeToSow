//
//  Сhallenge.swift
//  TimeToSow
//
//  Created by Nebo on 22.01.2026.
//

import Foundation

struct ChallengeSeason: Identifiable {
    let id: UUID
    let stableId: String
    let version: Int
    let title: String
    let startDate: Date
    let endDate: Date
    let challenges: [Challenge]
    
    init(id: UUID, stableId: String, version: Int, title: String, startDate: Date, endDate: Date, challenges: [Challenge]) {
        self.id = id
        self.stableId = stableId
        self.version = version
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.challenges = challenges
    }
    
    init(from: ChallengeSeasonModelGRDB) {
        self.id = from.id
        self.stableId = from.stableId
        self.version = from.version
        self.title = from.title
        self.startDate = from.startDate
        self.endDate = from.endDate
        self.challenges = from.challenges.map { Challenge(from: $0) }
    }
}

struct Challenge: Identifiable, Equatable {
    let id: String
    let title: String
    let type: ChallengeType
    let expectedValue: Int
    let expectedSecondValue: Int?
    let rewardDecor: DecorModel?
    let rewardRoom: RoomType?
    let rewardShelf: ShelfType?
    
    init(from: ChallengeModel) {
        id = from.id
        title = from.title
        type = from.type
        expectedValue = from.expectedValue
        expectedSecondValue = from.expectedSecondValue

        rewardDecor = from.reward
        rewardRoom = nil
        rewardShelf = nil
    }
}

struct CompletedChallenge {
    let challengeID: String
    var seasonID: String
    let date: Date
    
    init(id: String, seasonID: String, date: Date) {
        self.challengeID = id
        self.seasonID = seasonID
        self.date = date
    }
    
    init(from: CompletedChallengeModelGRDB) {
        self.challengeID = from.challengeID
        self.seasonID = from.seasonID
        self.date = from.date
    }
}
