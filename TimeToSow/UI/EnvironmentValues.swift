//
//  EnvironmentValues.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation
import SwiftUI

//struct ScreenBuilderKey: EnvironmentKey {
//    static var defaultValue = ScreenBuilder(appStore: appStore)
//}
//
//struct AppStoreKey: EnvironmentKey {
//    static var defaultValue = appStore
//}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: UIEdgeInsets {
        guard let scene = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first,
              let window = scene.windows.first(where: { $0.isKeyWindow }) else { return .zero }
        
        return window.safeAreaInsets
    }
}

//
//private struct SafeAreaInsetsKey: EnvironmentKey {
//    static var defaultValue: UIEdgeInsets {
//        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero)
//    }
//}

extension EnvironmentValues {
//    var screenBuilder: ScreenBuilder {
//        get { self[ScreenBuilderKey.self] }
//        set { self[ScreenBuilderKey.self] = newValue }
//    }
//    
//    var appStore: AppStore {
//        get { self[AppStoreKey.self] }
//        set { self[AppStoreKey.self] = newValue }
//    }
//    
    var safeAreaInsets: UIEdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}
