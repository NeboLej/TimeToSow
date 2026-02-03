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
    private var appStore: AppStore
    
    init() {
        let repositoryFactory = RepositoryFactory()
        
        let appStore = AppStore(factory: repositoryFactory)
        screenBuilder = ScreenBuilder(appStore: appStore, repositoryFactory: repositoryFactory)
        self.appStore = appStore
    }
    
    @State private var isShowContent = false
    
    var body: some Scene {
        
        WindowGroup {
            let coordinator = Bindable(appStore.appCoordinator)
            ZStack {
                NavigationStack(path: coordinator.path) {
                    if isShowContent {
                        ZStack {
                            screenBuilder.getScreen(type: .home)
                                .navigationDestination(for: ScreenType.self) {
                                    screenBuilder.getScreen(type: $0)
                                }
                            
                        }
                    }
                }
                screenBuilder.getComponent(type: .challengeCompleteView)
            }
            .onAppear {
                DispatchQueue.main.async {
                    isShowContent = true
                }
            }
            .sheet(item: coordinator.activeSheet, onDismiss: {
                
            }, content: { screenType in
                screenBuilder.getScreen(type: screenType)
            })
            .fullScreenCover(item: coordinator.fullScreenCover, content: { screenType in
                screenBuilder.getScreen(type: screenType)
            })
        }
    }
}

#if DEBUG
let screenBuilderMock: ScreenBuilder = {
    let repositoryFactory = RepositoryFactory()
    
    let appStore = AppStore(factory: repositoryFactory)
    return ScreenBuilder(appStore: appStore, repositoryFactory: repositoryFactory)
}()
#endif
