//
//  ChallengeService.swift
//  TimeToSow
//
//  Created by Nebo on 22.01.2026.
//

import Foundation

class ChallengeService {
    
    private let currentUserRoom: UserRoom
    private let challengeRepository: ChallengeRepositoryProtocol
    
    init(currentUserRoom: UserRoom, challengeRepository: ChallengeRepositoryProtocol) {
        self.currentUserRoom = currentUserRoom
        self.challengeRepository = challengeRepository
    }
    
    private let tmpRewardDecor1: Decor = Decor(id: UUID(), name: "Лошадка", locationType: .stand,
                                               animationOptions: AnimationOptions(duration: 1, repeatCount: 2, timeRepetition: 30),
                                               resourceName: "decor1", positon: .zero, height: 40)
    
    private let tmpRewardDecor2: Decor = Decor(id: UUID(), name: "Часики", locationType: .free,
                                               animationOptions: nil,
                                               resourceName: "decor2", positon: .zero, height: 40)
    
    private let tmpRewardDecor3: Decor = Decor(id: UUID(), name: "Колокольчик", locationType: .hand,
                                               animationOptions: nil,
                                               resourceName: "decor3", positon: .zero, height: 40)
    
    func getChallegeThisSeason() async -> ChallengeSeason? {
        return await challengeRepository.getCurrentChallengeSeason()
    }
    
//    func getChallegeThisSeason() -> ChallengeSeason {
//        ChallengeSeason(id: UUID(), version: 1, title: "Тестовый сезон!", startDate: Date(), endDate: Date().getOffsetDate(offset: 30),
//                        challenges: [
//                            Challenge(id: UUID(), title: "Полная загруженность", startDate: Date(), endDate: Date().getOffsetDate(offset: 30),
//                                      type: .totalLoggetTime, expectedValue: 30, expectedSecondValue: nil, rewardDecor: tmpRewardDecor1, rewardRoom: nil, rewardShelf: nil),
//                            
//                            Challenge(id: UUID(), title: "Зеленая полка", startDate: Date(), endDate: Date().getOffsetDate(offset: 30),
//                                      type: .numberOfPlants, expectedValue: 10, expectedSecondValue: nil, rewardDecor: tmpRewardDecor2, rewardRoom: nil, rewardShelf: nil),
//                            
//                            Challenge(id: UUID(), title: "Широкий фокус", startDate: Date(), endDate: Date().getOffsetDate(offset: 30),
//                                      type: .differentTagsUsed, expectedValue: 3, expectedSecondValue: nil, rewardDecor: tmpRewardDecor3, rewardRoom: nil, rewardShelf: nil),
//                            
//                            Challenge(id: UUID(), title: "Звездная коллекция", startDate: Date(), endDate: Date().getOffsetDate(offset: 30),
//                                      type: .numberOfPlantsNRarity, expectedValue: 4, expectedSecondValue: 8, rewardDecor: tmpRewardDecor1, rewardRoom: nil, rewardShelf: nil),
//                            
//                            Challenge(id: UUID(), title: "Стабильность", startDate: Date(), endDate: Date().getOffsetDate(offset: 30),
//                                      type: .oneTimeRecordingTime, expectedValue: 10, expectedSecondValue: 20, rewardDecor: tmpRewardDecor2, rewardRoom: nil, rewardShelf: nil),
//                            
//                            Challenge(id: UUID(), title: "Фиксируем отдых", startDate: Date(), endDate: Date().getOffsetDate(offset: 30),
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
