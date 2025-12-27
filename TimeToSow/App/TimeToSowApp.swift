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
        let myRoomRepository: MyRoomRepositoryProtocol = MyRoomRepository()
        let roomRepository: RoomRepositoryProtocol = RoomRepository()
        let shelfRepository: ShelfRepositoryProtocol = ShelfRepository()
        let seedRepository: SeedRepositoryProtocol = SeedRepository()
        let potRepository: PotRepositoryProtocol = PotRepository()
        let tagRepository: TagRepositoryProtocol = TagRepository()
        let plantRepository: PlantRepositoryProtocol = PlantRepository(seedRepository: seedRepository,
                                                                       potRepository: potRepository)
        
        let appStore = AppStore(myRoomRepository: myRoomRepository,
                                roomRepository: roomRepository,
                                shelfRepository: shelfRepository,
                                plantRepository: plantRepository,
                                tagRepository: tagRepository)
        screenBuilder = ScreenBuilder(appStore: appStore)
    }
    
    var body: some Scene {
        WindowGroup {
            screenBuilder.getScreen(type: .home)
        }
    }
}

#if DEBUG
let screenBuilderMock: ScreenBuilder = {
    let myRoomRepository: MyRoomRepositoryProtocol = MyRoomRepository()
    let roomRepository: RoomRepositoryProtocol = RoomRepository()
    let shelfRepository: ShelfRepositoryProtocol = ShelfRepository()
    let seedRepository: SeedRepositoryProtocol = SeedRepository()
    let potRepository: PotRepositoryProtocol = PotRepository()
    let tagRepository: TagRepositoryProtocol = TagRepository()
    let plantRepository: PlantRepositoryProtocol = PlantRepository(seedRepository: seedRepository,
                                                                   potRepository: potRepository)
    
    let appStore = AppStore(myRoomRepository: myRoomRepository,
                            roomRepository: roomRepository,
                            shelfRepository: shelfRepository,
                            plantRepository: plantRepository,
                            tagRepository: tagRepository)
    return ScreenBuilder(appStore: appStore)
}()
#endif
