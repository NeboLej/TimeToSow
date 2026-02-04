//
//  TimeToSowApp.swift
//  TimeToSow
//
//  Created by Nebo on 08.05.2025.
//

import SwiftUI

@main
struct TimeToSowApp: App {
    
    var screenBuilder: ScreenBuilder
    var appStore: AppStore
    
    init() {
        let repositoryFactory: RepositoryFactoryProtocol
#if DEBUG
        repositoryFactory = RepositoryFactoryMock()
        #else
        repositoryFactory = RepositoryFactory()
#endif
        let appStore = AppStore(factory: repositoryFactory)
        screenBuilder = ScreenBuilder(appStore: appStore, repositoryFactory: repositoryFactory)
        self.appStore = appStore
    }
    
    @State private var isShowContent = false
    
    var body: some Scene {
        WindowGroup {
            content()
        }
    }
    
    @ViewBuilder
    private func content() -> some View {
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
        .sheet(item: coordinator.activeSheet) { screenType in
            screenBuilder.getScreen(type: screenType)
        }
        .fullScreenCover(item: coordinator.fullScreenCover) { screenType in
            screenBuilder.getScreen(type: screenType)
        }
    }
}

#if DEBUG
let screenBuilderMock: ScreenBuilder = {
    let repositoryFactory = RepositoryFactoryMock()
    
    let appStore = AppStore(factory: repositoryFactory)
    return ScreenBuilder(appStore: appStore, repositoryFactory: repositoryFactory)
}()
#endif
