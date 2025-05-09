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
        screenBuilder = ScreenBuilder()
        
    }
    
    var body: some Scene {
        WindowGroup {
            screenBuilder.getScreen(type: .home)
        }
    }
}
