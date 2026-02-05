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
    var path = NavigationPath()
    
    private var screenStack: [ScreenType] = []
    
    init() {
        self.currentScreen = .home
    }
    
    func present(to newScreen: ScreenType, modal: Bool = false) {
        if !modal {
            fullScreenCover = newScreen
        } else {
            activeSheet = newScreen
        }
    }
    
    func navigate(to: ScreenType) {
        path.append(to)
    }
}
