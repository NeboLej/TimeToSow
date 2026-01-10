//
//  TimeToSowApp.swift
//  TimeToSow
//
//  Created by Nebo on 08.05.2025.
//

import SwiftUI
import SwiftData

//var sharedModelContainer: ModelContainer = {
//    let schema = Schema([TagModel.self, ShelfModel.self, SeedModel.self, RoomModel.self,
//                         PotModel.self, NoteModel.self, PlantModel.self, MonthRoomModel.self])
//    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//    do {
//        return try ModelContainer(for: schema, configurations: [modelConfiguration])
//    } catch {
//        fatalError("Could not create ModelContainer: \(error)")
//    }
//}()

import GRDB

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    let dbPool: DatabasePool
    
    private init() {
        let databaseURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("plantApp.sqlite")
        
        var config = Configuration()
        config.prepareDatabase { db in
            try db.execute(sql: "PRAGMA foreign_keys = ON")
            
            try Self.createTablesIfNeeded(in: db)
        }
        
        do {
            dbPool = try DatabasePool(path: databaseURL.path, configuration: config)
        } catch {
            fatalError("Ошибка создания DatabasePool: \(error)")
        }
    }
    
    private static func createTablesIfNeeded(in db: Database) throws {
        // Список всех таблиц — создаём по порядку (сначала те, на которые нет ссылок)
        try db.create(table: "tag", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("name", .text).notNull()
            t.column("color", .text).notNull()
        }
        
        try db.create(table: "shelf", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("name", .text).notNull()
            t.column("image", .text).notNull()
            t.column("shelfPositions", .blob).notNull()
        }
        
        try db.create(table: "room", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("name", .text).notNull()
            t.column("image", .text).notNull()
        }
        
        try db.create(table: "pot", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("potFeatures", .blob).notNull()
            t.column("name", .text).notNull()
            t.column("image", .text).notNull()
            t.column("height", .integer).notNull()
            t.column("rarity", .integer).notNull()
            t.column("anchorPointCoefficientX", .double)
            t.column("anchorPointCoefficientY", .double)
            t.column("width", .double).notNull()
        }
        
        try db.create(table: "seed", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("name", .text).notNull()
            t.column("unavailavlePotTypes", .blob).notNull()
            t.column("image", .text).notNull()
            t.column("height", .integer).notNull()
            t.column("rarity", .integer).notNull()
            t.column("rootCoordinateCoefX", .double)
            t.column("rootCoordinateCoefY", .double)
            t.column("width", .double).notNull()
        }
        
        try db.create(table: "userRoom", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("shelfID", .blob).notNull()
            t.column("roomID", .blob).notNull()
            t.column("name", .text).notNull()
            t.column("dateCreate", .double).notNull()
            
            t.foreignKey(["shelfID"], references: "shelf", onDelete: .restrict, onUpdate: .cascade)
            t.foreignKey(["roomID"], references: "room", onDelete: .restrict, onUpdate: .cascade)
        }
        
        try db.create(table: "plant", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("seedID", .blob).notNull()
            t.column("potID", .blob).notNull()
            t.column("name", .text).notNull()
            t.column("userDescription", .text).notNull()
            t.column("offsetY", .double).notNull()
            t.column("offsetX", .double).notNull()
            t.column("time", .integer).notNull()
            t.column("rootRoomID", .blob).notNull()
            
            t.foreignKey(["seedID"], references: "seed", onDelete: .restrict, onUpdate: .cascade)
            t.foreignKey(["potID"], references: "pot", onDelete: .restrict, onUpdate: .cascade)
            t.foreignKey(["rootRoomID"], references: "userRoom", onDelete: .cascade, onUpdate: .cascade)
        }
        
        try db.create(table: "note", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("date", .double).notNull()
            t.column("time", .integer).notNull()
            t.column("plantID", .blob).notNull()
            t.column("tagID", .blob).notNull()
            
            t.foreignKey(["plantID"],  references: "plant", onDelete: .cascade, onUpdate: .cascade)
            t.foreignKey(["tagID"], references: "tag", onDelete: .restrict, onUpdate: .cascade)
        }
    }
}

@main
struct TimeToSowApp: App {
    
    private var screenBuilder: ScreenBuilder
    private var appStore: AppStore
    
    init() {

//        let database: DatabaseRepositoryProtocol = DatabaseRepository(modelContainer: sharedModelContainer)
        let mock = MockDatabaseRepository()
        
        let tagRepository: TagRepositoryProtocol = TagRepository1(dbPool: DatabaseManager.shared.dbPool)
        let shelfRepository: ShelfRepositoryProtocol = ShelfRepository1(dbPool: DatabaseManager.shared.dbPool)
        let roomRepository: RoomRepositoryProtocol = RoomRepository1(dbPool: DatabaseManager.shared.dbPool)
        let seedRepository: SeedRepositoryProtocol = SeedRepository1(dbPool: DatabaseManager.shared.dbPool)
        let potRepository: PotRepositoryProtocol = PotRepository1(dbPool: DatabaseManager.shared.dbPool)
        let myRoomRepository: MyRoomRepositoryProtocol = UserRoomRepository(dbPool: DatabaseManager.shared.dbPool)
        let plantRepository: PlantRepositoryProtocol = PlantRepository1(dbPool: DatabaseManager.shared.dbPool,
                                                                        seedRepository: seedRepository,
                                                                        potRepository: potRepository)

        
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
