//
//  EditRoomScreen.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import SwiftUI

struct EditRoomScreen: View {
    
//    @Environment(\.appStore) var appStore: AppStore
    @State private var currentRoomType: RoomType?
    @State private var currentShelfType: ShelfType?
    @Environment(\.dismiss) var dismiss
    
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
                .padding(.top, 16)
            Spacer()
            HStack {
                Button {
                    dismiss()
                } label: {
                    TextEllipseStrokeView(text: "Cancel", font: .myButton(25), isSelected: true)
                        .foregroundStyle(Color(UIColor.systemPink))
                        .frame(width: 140, height: 50)
                }
                
                Button {
//                    appStore.setShelf(roomType: currentRoomType, shelfType: currentShelfType)
                    dismiss()
                } label: {
                    TextEllipseStrokeView(text: "Done", font: .myButton(25), isSelected: true)
                        .foregroundStyle(Color(UIColor.systemMint))
                        .frame(width: 140, height: 50)
                }
            }
            .padding(.bottom, 16)
        }
        .ignoresSafeArea()
        .onAppear {
//            currentRoomType = appStore.currentRoom.roomType
//            currentShelfType = appStore.currentRoom.shelfType
        }
    }
    
    @ViewBuilder
    private func editRoomControl() -> some View {
        VStack {
            Text("Edit room")
                .font(.myTitle(20))
            HStack {
                Image(systemName: "chevron.left")
                    .onTapGesture {
//                        currentRoomType = appStore.getNextRoom(currentRoom: currentRoomType!, isNext: false)
                    }
                Text(currentRoomType?.name ?? "")
                    .font(.myTitle(20))
                Image(systemName: "chevron.right")
                    .onTapGesture {
//                        currentRoomType = appStore.getNextRoom(currentRoom: currentRoomType!, isNext: true)
                    }
            }
        }
    }
    
    @ViewBuilder
    private func editShelfControl() -> some View {
        VStack {
            Text("Edit shelf")
                .font(.myTitle(20))
            HStack {
                Image(systemName: "chevron.left")
                    .onTapGesture {
//                        currentShelfType = appStore.getNextShelf(currentShelf: currentShelfType!, isNext: false)
                    }
                Text(currentShelfType?.name ?? "")
                    .font(.myTitle(20))
                Image(systemName: "chevron.right")
                    .onTapGesture {
//                        currentShelfType = appStore.getNextShelf(currentShelf: currentShelfType!, isNext: true)
                    }
            }
        }
    }
}

#Preview {
    EditRoomScreen()
}
