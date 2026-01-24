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
    private var imageRepository: ImageRepositoryProtocol
    
    init(appStore: AppStore, challengeService: ChallengeService, imageRepository: ImageRepositoryProtocol) {
        state = ChallengeState.empty
        self.challengeService = challengeService
        self.imageRepository = imageRepository
        super.init(appStore: appStore)
        
        getData()
    }
    
    private func getData() {
        Task {
            guard let currentSeason = await challengeService.getChallegeThisSeason() else { return }
            
            self.currentSeason = currentSeason
            
            progressList = try await asyncMap(currentSeason.challenges) { [weak self] in
                guard let self else { fatalError() }
                let progress = challengeService.getProgressBy(challenge: $0)
                return ChallengeProgress(challengeId: $0.id,
                                  name: $0.title,
                                  description: $0.type.getDescription(expectedValue: $0.expectedValue, expectedSecondValue: $0.expectedSecondValue),
                                  isCompleted: progress >= 1,
                                  progress: progress,
                                  rewardDecor: $0.rewardDecor,
                                  rewardUrl: await imageRepository.imageURL(for: $0.rewardDecor?.resourceUrl ?? ""))
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
