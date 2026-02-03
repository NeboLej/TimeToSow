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
    
    private var images: [String: URL?] = [:]
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
        case .reward(let challenge):
            appStore.send(.reward(challenge: challenge))
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
        challenges = appStore.completedChallenges
        state = RewardChallengeState(challanges: challenges)
        observeAppState()
    }
}
