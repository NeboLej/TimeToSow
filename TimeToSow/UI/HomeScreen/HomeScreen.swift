//
//  HomeScreen.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI

struct HomeScreen: View {
    
    @Environment(\.appStore) var appStore: AppStore
    @Environment(\.screenBuilder) var screenBuilder: ScreenBuilder
    
    var body: some View {
        ZStack {
            ScrollView {
                ShelfView(shelf: appStore.currentShelf)
                Group {
                    Rectangle()
                        .frame(height: 220)
                    Rectangle()
                        .frame(height: 300)
                    Rectangle()
                        .frame(height: 100)
                }
                .cornerRadius(20)
                .padding(.horizontal, 8)
                .offset(y: -20)
            }
        }.ignoresSafeArea(.all, edges: .top)
    }
}

#Preview {
    HomeScreen()
}
