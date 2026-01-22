//
//  ChallengeService.swift
//  TimeToSow
//
//  Created by Nebo on 22.01.2026.
//

import Foundation

class ChallengeService {
    
    private let currentUserRoom: UserRoom
    
    init(currentUserRoom: UserRoom) {
        self.currentUserRoom = currentUserRoom
    }
    
    private let tmpRewardDecor: Decor = Decor(id: UUID(), name: "Лошадка", locationType: .stand, animationOptions: AnimationOptions(duration: 1, repeatCount: 2, timeRepetition: 30),
                                              resourceName: "feature2", positon: .zero, height: 40, width: 40)
    
    
    func getChallegeThisSeason() -> ChallengeSeason {
        ChallengeSeason(id: UUID(), title: "Тестовый сезон!", startDate: Date(), endDate: Date().getOffsetDate(offset: 30),
                        challenges: [
                            Challenge(id: UUID(), title: "30 часов веселья!", startDate: Date(), endDate: Date().getOffsetDate(offset: 30),
                                      type: .totalLoggetTime, expectedValue: 30, expectedSecondValue: nil, rewardDecor: tmpRewardDecor, rewardRoom: nil, rewardShelf: nil),
                            
                            Challenge(id: UUID(), title: "10 растений!", startDate: Date(), endDate: Date().getOffsetDate(offset: 30),
                                      type: .numberOfPlants, expectedValue: 10, expectedSecondValue: nil, rewardDecor: tmpRewardDecor, rewardRoom: nil, rewardShelf: nil),
                            
                            Challenge(id: UUID(), title: "3 тэга разных!", startDate: Date(), endDate: Date().getOffsetDate(offset: 30),
                                      type: .differentTagsUsed, expectedValue: 3, expectedSecondValue: nil, rewardDecor: tmpRewardDecor, rewardRoom: nil, rewardShelf: nil),
                            
                        ])
    }
    
    func getProgressBy(challenge: Challenge) -> Double {
        if challenge.expectedValue <= 0 { return 0 }
        
        switch challenge.type {
        case .totalLoggetTime:
            return totalLoggetTime(expected: challenge.expectedValue)
        case .numberOfPlants:
            return numberOfPlants(expected: challenge.expectedValue)
        case .differentTagsUsed:
            return differentTagsUsed(expected: challenge.expectedValue)
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
}
