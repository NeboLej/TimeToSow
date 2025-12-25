//
//  EnvironmentValues.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation
import SwiftUI

struct ScreenBuilderKey: EnvironmentKey {
    static var defaultValue = ScreenBuilder(appStore: AppStore(myRoomRepository: MyRoomRepository(),
                                                               roomRepository: RoomRepository(),
                                                               shelfRepository: ShelfRepository(),
                                                               seedRepository: SeedRepository(),
                                                               potRepository: PotRepository(),
                                                               tagRepository: TagRepository()))
}

struct AppStoreKey: EnvironmentKey {
    static var defaultValue = AppStore(myRoomRepository: MyRoomRepository(),
                                       roomRepository: RoomRepository(),
                                       shelfRepository: ShelfRepository(),
                                       seedRepository: SeedRepository(),
                                       potRepository: PotRepository(),
                                       tagRepository: TagRepository())
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
