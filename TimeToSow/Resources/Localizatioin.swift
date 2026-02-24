//
//  Localizatioin.swift
//  TimeToSow
//
//  Created by Nebo on 24.02.2026.
//

import Foundation

enum Lo {
    
    enum Button {
        static let start = String(localized: "Button.Start")
        static let getReward = String(localized: "Button.GetReward")
        static let inABox = String(localized: "Button.InABox")
        static let onShelf = String(localized: "Button.OnShelf")
    }
    
    enum HomeScreen {
        static let newPlantTitle = String(localized: "HomeScreen.newPlantTitle")
        static let updatePlantTitle = String(localized: "HomeScreen.upgradePlantTitle")
        static let monthStatistic_PlantCount = String(localized: "HomeScreen.MonthStatistic.plantCountText")
        static let monthStatistic_BonusCount = String(localized: "HomeScreen.MonthStatistic.bonusCountText")
        static let monthStatistic_TopPlant = String(localized: "HomeScreen.MonthStatistic.topPlantText")
        static let monthStatistic_TopTag = String(localized: "HomeScreen.MonthStatistic.topTagText")
    }
    
    enum RewardChallenge {
        static let challengeComplete = String(localized: "ChallengeCompleteView.ChallengeComplete")
        
        static func rewarding(_ string: String) -> String {
            String(format: String(localized: "ChallengeCompleteView.Rewarding"), string)
        }
        
    }
}
