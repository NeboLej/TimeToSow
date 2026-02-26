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
        static let save = String(localized: "Button.save")
        static let delete = String(localized: "Button.delete")
        static let cancel = String(localized: "Button.cancel")
        static let edit = String(localized: "Button.edit")
    }
    
    enum HomeScreen {
        static let newPlantTitle = String(localized: "HomeScreen.newPlantTitle")
        static let updatePlantTitle = String(localized: "HomeScreen.upgradePlantTitle")
    }
    
    enum MonthStatistic {
        static let plantCount = String(localized: "MonthStatistic.plantCountText")
        static let bonusCount = String(localized: "MonthStatistic.bonusCountText")
        static let topPlant = String(localized: "MonthStatistic.topPlantText")
        static let topTag = String(localized: "MonthStatistic.topTagText")
    }
    
    enum BoxScreen {
        static let title = String(localized: "BoxScreen.title")
        static let pickerPlants = String(localized: "BoxScreen.Picker.plants")
        static let pickerDecor = String(localized: "BoxScreen.Picker.decor")
        static let emptyStatePlants = String(localized: "BoxScreen.EmptyState.plants")
        static let emptyStateDecor = String(localized: "BoxScreen.EmptyState.decor")
        static let cellMenuInfo = String(localized: "BoxScreen.CellMenu.info")
        static let cellMenuOnShelf = String(localized: "BoxScreen.CellMenu.onShelf")
    }
    
    enum ChallengeScreen {
        static let title = String(localized: "ChallengeScreen.title")
        static let emptyState = String(localized: "ChallengeScreen.emptyState")
        static let allChallengesDescriptioin = String(localized: "ChallengeScreen.description")
        
        
        static func endSeasonDate(_ string: String) -> String {
            String(format: String(localized: "ChallengeCompleteView.endSeasonDate"), string)
        }
    }
    
    enum TagsScreen {
        static let newTagPlaceholder = String(localized: "TagsScreen.newTagPlaceholder")
        static let newTagTextFieldPlaceholder = String(localized: "TagsScreen.TextField.placeholder")
        static let deleteAlertMessage = String(localized: "TagsScreen.deleteAlertMessage")
        static let colorPickerTitle = String(localized: "TagsScreen.colorPickerTitle")
    }
    
    enum RewardChallenge {
        static let challengeComplete = String(localized: "ChallengeCompleteView.ChallengeComplete")
        
        static func rewarding(_ string: String) -> String {
            String(format: String(localized: "ChallengeCompleteView.Rewarding"), string)
        }
    }
    
    enum HistoryScreen {
        static let title = String(localized: "HistoryScreen.title")
        static let recordsHistoryTitle = String(localized: "HistoryScreen.recordsHistoryTitle")
    }
    
    enum PlantDetailScreen {
        static let recordsHistoryTitle = String(localized: "PlantDetailScreen.recordsTitle")
        static let descriptionTitle = String(localized: "PlantDetailScreen.descriptionTitle")
        static let returnToShelfButton = String(localized: "PlantDetailScreen.returnToShelfButton")
        static let removeFromShelfButton = String(localized: "PlantDetailScreen.removeFromShelfButton")
        static let deletePlantAlertMessage = String(localized: "PlantDetailScreen.Alert.DeletePlant.message")
    }
    
    enum ProgressScreen {
        static let sliderOfPhrases1 = String(localized: "ProgressScreen.sliderOfPhrases_1")
        static let stopAlertMessage = String(localized: "ProgressScreen.Alert.Stop.message")
        static let stopAlertPositive = String(localized: "ProgressScreen.Alert.Stop.positiveAction")
        static let stopAlertNegative = String(localized: "ProgressScreen.Alert.Stop.negativeAction")
        static let completeProgressTitle = String(localized: "ProgressScreen.completeProgressTitle")
        static let onShelfButton = String(localized: "ProgressScreen.onShelfButton")
        
        static func plantName(seed: String, pot: String) -> String {
            String(format: String(localized: "ProgressScreen.plantName"), seed, pot)
        }
    }
}
