//
//  ChallengeService.swift
//  TimeToSow
//
//  Created by Nebo on 22.01.2026.
//

import Foundation

final class ChallengeService {
    
    private var currentUserRoom: UserRoom = .empty
    private let challengeRepository: ChallengeRepositoryProtocol
    private var challengeSeason: ChallengeSeason?
    private var rebuildTask: Task<Void, Never>?
    private var completedChallenges: [CompletedChallenge] = []
    
    init(challengeRepository: ChallengeRepositoryProtocol) {
        self.challengeRepository = challengeRepository
    }
    
    func startObservation(appStore: AppStore) {
        Task {
            challengeSeason = await challengeRepository.getCurrentChallengeSeason()
            guard let challengeSeason else { return }
            completedChallenges = await challengeRepository.getAllCompletedChallanges(seasonID: challengeSeason.stableId)
            await rebuildState(appStore: appStore)
        }
    }
    
    func getChallegeThisSeason() async -> ChallengeSeason? {
        return await challengeRepository.getCurrentChallengeSeason()
    }

    //MARK: - Private
    private func observeAppState(appStore: AppStore) {
        withObservationTracking {
            _ = appStore.currentRoom.plants
        } onChange: { [weak self] in
            guard let self else { return }
            
            rebuildTask?.cancel()
            
            rebuildTask = Task.detached(priority: .utility) {
                do {
                    try await Task.sleep(for: .seconds(5))
                    await self.rebuildState(appStore: appStore)
                } catch {
                    Logger.log("Error observeAppState", location: .challengeService, event: .error(error))
                }
            }
        }
    }
    
    private func rebuildState(appStore: AppStore) async {
        guard let challengeSeason else {
            observeAppState(appStore: appStore)
            return
        }
        currentUserRoom = appStore.currentRoom
        
        let uncompletedChallenges = challengeSeason.challenges.filter { seasonChallenge in
            !completedChallenges.contains(where: { $0.id == seasonChallenge.id })
        }
        let newCompletedChallenges = uncompletedChallenges.filter { getProgressBy(challenge: $0) >= 1 }
        
        if !newCompletedChallenges.isEmpty {
            let newCompletedChallengesModels = newCompletedChallenges.map {
                CompletedChallenge(id: $0.id, seasonID: challengeSeason.stableId, date: Date())
            }
            
            await MainActor.run {
                Logger.log("Complete new challenge", location: .challengeService, event: .success)
                appStore.send(.completeChallenges(newCompletedChallenges))
            }
            
            await challengeRepository.saveCompletedChallenges(newCompletedChallengesModels)
            completedChallenges.append(contentsOf: newCompletedChallengesModels)
        }
        observeAppState(appStore: appStore)
    }
    
//    func getChallegeThisSeason() -> ChallengeSeason {
//        ChallengeSeason(id: UUID(), version: 1, title: "Тестовый сезон!", startDate: Date(), endDate: Date().getOffsetDate(days: 30),
//                        challenges: [
//                            Challenge(id: UUID(), title: "Полная загруженность", startDate: Date(), endDate: Date().getOffsetDate(days: 30),
//                                      type: .totalLoggetTime, expectedValue: 30, expectedSecondValue: nil, rewardDecor: tmpRewardDecor1, rewardRoom: nil, rewardShelf: nil),
//                            
//                            Challenge(id: UUID(), title: "Зеленая полка", startDate: Date(), endDate: Date().getOffsetDate(days: 30),
//                                      type: .numberOfPlants, expectedValue: 10, expectedSecondValue: nil, rewardDecor: tmpRewardDecor2, rewardRoom: nil, rewardShelf: nil),
//                            
//                            Challenge(id: UUID(), title: "Широкий фокус", startDate: Date(), endDate: Date().getOffsetDate(days: 30),
//                                      type: .differentTagsUsed, expectedValue: 3, expectedSecondValue: nil, rewardDecor: tmpRewardDecor3, rewardRoom: nil, rewardShelf: nil),
//                            
//                            Challenge(id: UUID(), title: "Звездная коллекция", startDate: Date(), endDate: Date().getOffsetDate(days: 30),
//                                      type: .numberOfPlantsNRarity, expectedValue: 4, expectedSecondValue: 8, rewardDecor: tmpRewardDecor1, rewardRoom: nil, rewardShelf: nil),
//                            
//                            Challenge(id: UUID(), title: "Стабильность", startDate: Date(), endDate: Date().getOffsetDate(days: 30),
//                                      type: .oneTimeRecordingTime, expectedValue: 10, expectedSecondValue: 20, rewardDecor: tmpRewardDecor2, rewardRoom: nil, rewardShelf: nil),
//                            
//                            Challenge(id: UUID(), title: "Фиксируем отдых", startDate: Date(), endDate: Date().getOffsetDate(days: 30),
//                                      type: .weekendProductivity, expectedValue: 5, expectedSecondValue: nil, rewardDecor: tmpRewardDecor3, rewardRoom: nil, rewardShelf: nil),
//                            
//                        ]
//        )
//    }
    
    func getProgressBy(challenge: Challenge) -> Double {
        if challenge.expectedValue <= 0 { return 0 }
        
        switch challenge.type {
        case .totalLoggetTime:
            return totalLoggetTime(expected: challenge.expectedValue)
        case .numberOfPlants:
            return numberOfPlants(expected: challenge.expectedValue)
        case .differentTagsUsed:
            return differentTagsUsed(expected: challenge.expectedValue)
        case .numberOfPlantsNRarity:
            guard let rarityValue = challenge.expectedSecondValue else { return 0 }
            return numberOfPlantsNRarity(expected: challenge.expectedValue, rarity: rarityValue)
        case .oneTimeRecordingTime:
            guard let expectedTime = challenge.expectedSecondValue else { return 0 }
            return oneTimeRecordingTime(expected: challenge.expectedValue, time: expectedTime)
        case .weekendProductivity:
            return weekendProductivity(expected: challenge.expectedValue)
        default: return 0
        }
    }
    
    private func totalLoggetTime(expected: Int) -> Double {
        let allTime = currentUserRoom.plants.values.reduce(0) { $0 + $1.time }
        let progress = Double(allTime) / (Double(expected) * 60)
        return progress
    }
    
    private func numberOfPlants(expected: Int) -> Double {
        let allPlantsCount = currentUserRoom.plants.count
        let progress = Double(allPlantsCount) / Double(expected)
        return progress
    }
    
    private func differentTagsUsed(expected: Int) -> Double {
        let uniqueTags: Set<Tag> = Set(currentUserRoom.plants.flatMap { $0.value.notes }.map { $0.tag })
        let progress = Double(uniqueTags.count) / Double(expected)
        return progress
    }
    
    private func numberOfPlantsNRarity(expected: Int, rarity: Int) -> Double {
        let plantCount = currentUserRoom.plants.filter { ($0.value.seed.rarity.starCount + $0.value.pot.rarity.starCount) == rarity }.count
        let progress = Double(plantCount) / Double(expected)
        return progress
    }
    
    private func oneTimeRecordingTime(expected: Int, time: Int) -> Double {
        let filtredNotes = currentUserRoom.plants.flatMap { $0.value.notes }.filter { $0.time == time }
        let progress = Double(filtredNotes.count) / Double(expected)
        return progress
    }
    
    private func weekendProductivity(expected: Int) -> Double {
        let allNotes = currentUserRoom.plants.flatMap { $0.value.notes }
        let weekends = allNotes.filter {
            let weekday = Calendar.current.component(.weekday, from: $0.date)
            return weekday == 1 || weekday == 7
        }
        let progress = Double(weekends.count) / Double(expected)
        return progress
    }
}
