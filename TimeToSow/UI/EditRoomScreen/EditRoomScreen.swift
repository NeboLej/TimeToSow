//
//  EditRoomScreen.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import SwiftUI

struct EditRoomScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @State var store: EditRoomStore
    
    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Image(store.state.selectedRoom.image)
                    .resizable()
                Image(store.state.selectedShelf.image)
                    .resizable()
            }
            .frame(height: 400)
            roomsList()
                .padding(.bottom, 16)
            shelfList()
            
            Spacer()
            HStack {
                TextureButton(label: "Cancel", color: .strokeAcsent2) {
                    dismiss()
                }
                TextureButton(label: "Save", color: .strokeAcsent1) {
                    store.send(.save)
                    dismiss()
                }
            }
            .padding(.bottom, 16)
        }
        .ignoresSafeArea()
        .background(.mainBackground)
    }
    
    @ViewBuilder
    private func roomsList() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(store.state.allRooms) { room in
                    imageCell(imageName: room.image)
                        .overlay(alignment: .topTrailing) {
                            if store.selectedRoom.id == room.id {
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.strokeAcsent2)
                            } else {
                                EmptyView()
                            }
                        }
                        .onTapGesture {
                            store.send(.selectRoom(room))
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    private func shelfList() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(store.state.allShelfs) { shelf in
                    imageCell(imageName: shelf.image)
                        .overlay(alignment: .topTrailing) {
                            if store.selectedShelf.id == shelf.id {
                                Circle()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.strokeAcsent2)
                            } else {
                                EmptyView()
                            }
                        }
                        .onTapGesture {
                            store.send(.selectShelf(shelf))
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    private func imageCell(imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            .background(.gray.opacity(0.3))
            .cornerRadius(20, corners: .allCorners)

    }
}

#Preview {
    screenBuilderMock.getScreen(type: .editRoom)
}
