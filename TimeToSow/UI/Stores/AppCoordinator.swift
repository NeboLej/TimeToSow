//
//  AppCoordinator.swift
//  TimeToSow
//
//  Created by Nebo on 21.12.2025.
//

import SwiftUI

@Observable
class AppCoordinator {
    var currentScreen: ScreenType?
    var activeSheet: ScreenType? = nil
    var fullScreenCover: ScreenType? = nil
    
    private var screenStack: [ScreenType] = []
    
    init() {
        self.currentScreen = .home
    }
    
    func navigate(to newScreen: ScreenType, modal: Bool = false) {
        if !modal {
            fullScreenCover = newScreen
        } else {
            activeSheet = newScreen
        }
    }
}
