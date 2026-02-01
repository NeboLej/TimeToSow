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
    
    let seasonIsActive: Bool
    
    init(seasonName: String, seasonDescription: String, challengeProgress: [ChallengeProgress], seasonStartDate: Date, seasonEndDate: Date) {
        self.seasonName = seasonName
        self.seasonDescription = seasonDescription
        self.challengeProgress = challengeProgress
        self.seasonStartDate = seasonStartDate
        self.seasonEndDate = seasonEndDate
        
        if seasonStartDate < seasonEndDate {
            seasonIsActive = (seasonStartDate...seasonEndDate).contains(Date()) && !challengeProgress.isEmpty
        } else {
            seasonIsActive = false
        }
    }
    
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
