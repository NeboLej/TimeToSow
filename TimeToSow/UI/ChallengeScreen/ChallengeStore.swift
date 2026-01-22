//
//  ChallengeStore.swift
//  TimeToSow
//
//  Created by Nebo on 22.01.2026.
//

import Foundation

@Observable
final class ChallengeStore: FeatureStore {
    
    var state: ChallengeState
    private var challengeService: ChallengeService
    private var progressList: [ChallengeProgress] = []
    private var currentSeason: ChallengeSeason?
    
    init(appStore: AppStore, challengeService: ChallengeService) {
        state = ChallengeState.empty
        self.challengeService = challengeService
        super.init(appStore: appStore)
        
        getData()
    }
    
    private func getData() {
        Task {
            let currentSeason = challengeService.getChallegeThisSeason()
            self.currentSeason = currentSeason
            progressList = currentSeason.challenges.map {
                let progress = challengeService.getProgressBy(challenge: $0)
                return ChallengeProgress(challengeId: $0.id,
                                  name: $0.title,
                                  description: $0.type.getDescription(expectedValue: $0.expectedValue, expectedSecondValue: $0.expectedSecondValue),
                                  isCompleted: progress >= 1,
                                  progress: progress,
                                  rewardDecor: $0.rewardDecor)
            }
            rebuildState()
        }
    }
    
    private func rebuildState() {
        guard let season = currentSeason else { return }
        
        state = ChallengeState(seasonName: season.title, seasonDescription: "", challengeProgress: progressList,
                               seasonStartDate: season.startDate, seasonEndDate: season.endDate)
    }
}
