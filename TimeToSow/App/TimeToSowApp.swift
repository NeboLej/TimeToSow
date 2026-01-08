//
//  TimeToSowApp.swift
//  TimeToSow
//
//  Created by Nebo on 08.05.2025.
//

import SwiftUI
import SwiftData

var sharedModelContainer: ModelContainer = {
    let schema = Schema([TagModel.self, ShelfModel.self, SeedModel.self])
//    ShelfPositionsJSONTransformer.register()
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()


@main
struct TimeToSowApp: App {
    
    private var screenBuilder: ScreenBuilder
    private var appStore: AppStore
    
    init() {
        let database: DatabaseRepositoryProtocol = DatabaseRepository(modelContainer: sharedModelContainer)
//        do {
//            let container: ModelContainer = try ModelContainer(for: TagModel.self, DummyModel.self)
//            database = DatabaseRepository(modelContainer: container)
//        } catch {
//            fatalError("Failed to create container: \(error)")
//        }
        
        
        let myRoomRepository: MyRoomRepositoryProtocol = MyRoomRepository(database: database)
        let roomRepository: RoomRepositoryProtocol = RoomRepository(database: database)
        let shelfRepository: ShelfRepositoryProtocol = ShelfRepository(database: database)
        let seedRepository: SeedRepositoryProtocol = SeedRepository(database: database)
        let potRepository: PotRepositoryProtocol = PotRepository(database: database)
        let tagRepository: TagRepositoryProtocol = TagRepository(database: database)
        let plantRepository: PlantRepositoryProtocol = PlantRepository(seedRepository: seedRepository,
                                                                       potRepository: potRepository,
                                                                       database: database)
        
        let appStore = AppStore(myRoomRepository: myRoomRepository,
                                roomRepository: roomRepository,
                                shelfRepository: shelfRepository,
                                plantRepository: plantRepository,
                                tagRepository: tagRepository)
        screenBuilder = ScreenBuilder(appStore: appStore)
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
    let database: DatabaseRepositoryProtocol = MockDatabaseRepository()
    
    let myRoomRepository: MyRoomRepositoryProtocol = MyRoomRepository(database: database)
    let roomRepository: RoomRepositoryProtocol = RoomRepository(database: database)
    let shelfRepository: ShelfRepositoryProtocol = ShelfRepository(database: database)
    let seedRepository: SeedRepositoryProtocol = SeedRepository(database: database)
    let potRepository: PotRepositoryProtocol = PotRepository(database: database)
    let tagRepository: TagRepositoryProtocol = TagRepository(database: database)
    let plantRepository: PlantRepositoryProtocol = PlantRepository(seedRepository: seedRepository,
                                                                   potRepository: potRepository,
                                                                   database: database)
    
    let appStore = AppStore(myRoomRepository: myRoomRepository,
                            roomRepository: roomRepository,
                            shelfRepository: shelfRepository,
                            plantRepository: plantRepository,
                            tagRepository: tagRepository)
    return ScreenBuilder(appStore: appStore)
}()
#endif
