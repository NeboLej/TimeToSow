//
//  TimeToSowApp.swift
//  TimeToSow
//
//  Created by Nebo on 08.05.2025.
//

import SwiftUI
import GRDB

class RepositoryFactory {
    let tagRepository: TagRepositoryProtocol = TagRepository(dbPool: DatabaseManager.shared.dbPool)
    let shelfRepository: ShelfRepositoryProtocol = ShelfRepository(dbPool: DatabaseManager.shared.dbPool)
    let roomRepository: RoomRepositoryProtocol = RoomRepository(dbPool: DatabaseManager.shared.dbPool)
    let seedRepository: SeedRepositoryProtocol = SeedRepository(dbPool: DatabaseManager.shared.dbPool)
    let potRepository: PotRepositoryProtocol = PotRepository(dbPool: DatabaseManager.shared.dbPool)
    let myRoomRepository: UserRoomRepositoryProtocol = UserRoomRepository(dbPool: DatabaseManager.shared.dbPool)
    let challengeRepository: ChallengeRepositoryProtocol = ChallengeRepository(dbPool: DatabaseManager.shared.dbPool)
    
    lazy var remoteRepository = RemoteContentRepository(challengeRepository: challengeRepository)
    lazy var plantRepository: PlantRepositoryProtocol = PlantRepository(dbPool: DatabaseManager.shared.dbPool,
                                                                    seedRepository: seedRepository,
                                                                    potRepository: potRepository)
}


@main
struct TimeToSowApp: App {
    
    private var screenBuilder: ScreenBuilder
    private var appStore: AppStore
    
    init() {

        let repositoryFactory = RepositoryFactory()
        
        let appStore = AppStore(factory: repositoryFactory)
        screenBuilder = ScreenBuilder(appStore: appStore, repositoryFactory: repositoryFactory)
        self.appStore = appStore
        
        loadLocalJSONLocalization()
    }
    
    @State private var isShowContent = false
    
    var body: some Scene {
        
        WindowGroup {
            let coordinator = Bindable(appStore.appCoordinator)
            
            NavigationStack(path: coordinator.path) {
                if isShowContent {
                    screenBuilder.getScreen(type: .home)
                        .navigationDestination(for: ScreenType.self) {
                            screenBuilder.getScreen(type: $0)
                        }
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    isShowContent = true
                }
            }
            .sheet(item: coordinator.activeSheet, onDismiss: {
                print("dismiss")
            }, content: { screenType in
                screenBuilder.getScreen(type: screenType)
            })
            .fullScreenCover(item: coordinator.fullScreenCover, content: { screenType in
                screenBuilder.getScreen(type: screenType)
            })
        }
    }
    
    private func loadLocalJSONLocalization() {
        guard let url = Bundle.main.url(forResource: "remote_localization", withExtension: "json") else {
            assertionFailure("Localization JSON not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            try JSONLocalizationService.shared.load(from: data)
        } catch {
            assertionFailure("Failed to load localization: \(error)")
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
