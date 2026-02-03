//
//  RewardChallengeStore.swift
//  TimeToSow
//
//  Created by Nebo on 02.02.2026.
//

import Foundation

@Observable
final class RewardChallengeStore: FeatureStore {
    
    var state: RewardChallengeState
    
    private var challenges: [Challenge] = []
    
    override init(appStore: AppStore) {
        self.state = RewardChallengeState(challanges: [])
        
        super.init(appStore: appStore)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.rebuildState()
        }
    }
    
    func send(_ action: RewardChallengeAction) {
        switch action {
        case .reward(let challenge, let isUse):
            appStore.send(.reward(challenge: challenge, isUse: isUse))
        }
    }
    
    private func observeAppState() {
        withObservationTracking {
            _ = appStore.completedChallenges
        } onChange: {
            self.rebuildState()
        }
    }
    
    private func rebuildState() {
        Task {
            await MainActor.run {
                challenges = appStore.completedChallenges
                state = RewardChallengeState(challanges: challenges)
            }
            observeAppState()
        }
    }
}
