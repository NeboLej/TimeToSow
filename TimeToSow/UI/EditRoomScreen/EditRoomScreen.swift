//
//  EditRoomScreen.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import SwiftUI

struct EditRoomScreen: View {
    
    @Environment(\.appStore) var appStore: AppStore
    @State private var currentRoomType: RoomType?
    @State private var currentShelfType: ShelfType?
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Image(currentRoomType?.image ?? "")
                    .resizable()
                Image(currentShelfType?.image ?? "")
                    .resizable()
            }
            .frame(height: 400)
            editRoomControl()
            editShelfControl()
            Spacer()
        }
        .ignoresSafeArea()
        .onAppear {
            currentRoomType = appStore.currentRoom.roomType
            currentShelfType = appStore.currentRoom.shelfType
        }
    }
    
    @ViewBuilder
    private func editRoomControl() -> some View {
        VStack {
            Text("Edit room")
            HStack {
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        currentRoomType = appStore.getNextRoom(currentRoom: currentRoomType!, isNext: false)
                    }
                Text(currentRoomType?.name ?? "")
                Image(systemName: "chevron.right")
                    .onTapGesture {
                        currentRoomType = appStore.getNextRoom(currentRoom: currentRoomType!, isNext: true)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func editShelfControl() -> some View {
        VStack {
            Text("Edit shelf")
            HStack {
                Image(systemName: "chevron.left")
                    .onTapGesture {
                        currentShelfType = appStore.getNextShelf(currentShelf: currentShelfType!, isNext: false)
                    }
                Text(currentShelfType?.name ?? "")
                Image(systemName: "chevron.right")
                    .onTapGesture {
                        currentShelfType = appStore.getNextShelf(currentShelf: currentShelfType!, isNext: true)
                    }
            }
        }
    }
}

#Preview {
    EditRoomScreen()
}
