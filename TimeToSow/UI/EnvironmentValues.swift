//
//  EnvironmentValues.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation
import SwiftUI

fileprivate let appStore: AppStore  = {
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
    return appStore
}()

struct ScreenBuilderKey: EnvironmentKey {
    static var defaultValue = ScreenBuilder(appStore: appStore)
}

struct AppStoreKey: EnvironmentKey {
    static var defaultValue = appStore
}


private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: UIEdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero)
    }
}

extension EnvironmentValues {
    var screenBuilder: ScreenBuilder {
        get { self[ScreenBuilderKey.self] }
        set { self[ScreenBuilderKey.self] = newValue }
    }
    
    var appStore: AppStore {
        get { self[AppStoreKey.self] }
        set { self[AppStoreKey.self] = newValue }
    }
    
    var safeAreaInsets: UIEdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}
