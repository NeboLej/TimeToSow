//
//  TimeToSowApp.swift
//  TimeToSow
//
//  Created by Nebo on 08.05.2025.
//

import SwiftUI

@main
struct TimeToSowApp: App {
    
    private var screenBuilder: ScreenBuilder
    
    init() {
        let shelfRepository: ShelfRepositoryProtocol = ShelfRepository()
        let appStore = AppStore(shelfRepository: shelfRepository)
        screenBuilder = ScreenBuilder(appStore: appStore)
    }
    
    var body: some Scene {
        WindowGroup {
            screenBuilder.getScreen(type: .home)
        }
    }
}
