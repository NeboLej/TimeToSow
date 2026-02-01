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
    
    private var images: [UUID: URL?] = [:]
    private var challenges: [Challenge] = []
    
    @ObservationIgnored
    private var imageRepository: ImageRepositoryProtocol
    
    init(appStore: AppStore, imageRepository: ImageRepositoryProtocol) {
        self.imageRepository = imageRepository
        self.state = RewardChallengeState(challanges: [], images: [:])
        
        super.init(appStore: appStore)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.loadingImages()
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
            self.loadingImages()
        }
    }
    
    private func loadingImages() {
        Task {
            let needImageArray = appStore.completedChallenges.filter { images[$0.id] == nil }
            
            let urls = try await asyncMap(needImageArray) { [weak self] in
                guard let self else { fatalError() }
                return ($0, await imageRepository.imageURL(for: $0.rewardDecor?.resourceUrl ?? "") )
            }
            
            await MainActor.run {
                var newImages: [UUID: URL?] = [:]
                urls.forEach { challange, url in
                    newImages[challange.id] = url
                }
                images = newImages
                rebuildState()
            }
        }
    }
    
    private func rebuildState() {
        challenges = appStore.completedChallenges
        state = RewardChallengeState(challanges: challenges, images: images)
        observeAppState()
    }
}
