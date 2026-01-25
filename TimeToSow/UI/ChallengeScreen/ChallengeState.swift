//
//  ChallengeState.swift
//  TimeToSow
//
//  Created by Nebo on 22.01.2026.
//

import Foundation

struct ChallengeState: Equatable {
    let seasonName: String
    let seasonDescription: String
    let challengeProgress: [ChallengeProgress]
    let seasonStartDate: Date
    let seasonEndDate: Date
    
    static let empty: ChallengeState = .init(
        seasonName: "",
        seasonDescription: "",
        challengeProgress: [],
        seasonStartDate: Date(),
        seasonEndDate: Date()
    )
}

struct ChallengeProgress: Identifiable, Equatable {
    let id: UUID = UUID()
    let challengeId: UUID
    let name: String
    let description: String
    let isCompleted: Bool
    let progress: Double
    let rewardDecor: DecorModel?
    let rewardUrl: URL?
}
