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
    private var challengeService: ChallengeServiceProtocol
    private var progressList: [ChallengeProgress] = []
    private var currentSeason: ChallengeSeason?
    
    init(appStore: AppStore, challengeService: ChallengeServiceProtocol) {
        state = ChallengeState.empty
        self.challengeService = challengeService
        super.init(appStore: appStore)
        
        getData()
    }
    
    private func getData() {
        Task {
            guard let currentSeason = await challengeService.getChallegeThisSeason() else { return }
            
            self.currentSeason = currentSeason
            
            progressList = currentSeason.challenges.map {
                let progress = min(challengeService.getProgressBy(challenge: $0), 1)
                return ChallengeProgress(challengeId: $0.id,
                                  name: $0.title,
                                  description: $0.type.getDescription(expectedValue: $0.expectedValue, expectedSecondValue: $0.expectedSecondValue),
                                  isCompleted: progress == 1,
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

func asyncMap<T, U>(_ items: [T], transform: @escaping (T) async throws -> U) async throws -> [U] {
    try await withThrowingTaskGroup(of: (Int, U).self) { group in
        for (index, item) in items.enumerated() {
            group.addTask {
                (index, try await transform(item))
            }
        }

        var result = Array<U?>(repeating: nil, count: items.count)

        for try await (index, value) in group {
            result[index] = value
        }

        return result.compactMap { $0 }
    }
}
