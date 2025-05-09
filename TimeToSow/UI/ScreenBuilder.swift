//
//  ScreenBuilder.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI

enum ScreenType {
    case home
}

enum ComponentType {
    
}

final class ScreenBuilder {
    
    
    @ViewBuilder
    func getScreen(type: ScreenType) -> some View {
        switch type {
        case .home:
            HomeScreen()
        }
    }
    
    @ViewBuilder
    func getComponent(type: ComponentType) -> some View {
        
    }
}
