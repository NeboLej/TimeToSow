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
    
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State private var grandColor: Color = .clear
    @State private var activityType: Int = 0
    @State private var selectedTime: Int = 50
    @State private var selectedElement: PickerElement = .new
    @State private var isShowEditRoom = false
    @State private var isProgress = false
    
    var store: HomeScreenStore
    
    var body: some View {
        VStack(spacing: 0) {
            header()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    roomView()
                        .zIndex(100)
                    newPlantSection()
#if DEBUG
                    debugConsole()
#endif
                }
            }.coordinateSpace(name: "SCROLL")
        }
        .background(
            Color(hex: "FFF9EE")
                .overlay(
                    Image(.texture2)
                        .resizable()
                        .blendMode(.multiply)
                        .opacity(0.9)
                )
        )
        .ignoresSafeArea(.all)
        .sheet(isPresented: $isShowEditRoom, onDismiss: {
//            store.bindRoom(appStore.currentRoom)
        }, content: {
            screenBuilder.getScreen(type: .editRoom)
        })
        .fullScreenCover(isPresented: $isProgress, onDismiss: {
            isProgress = false
        }, content: {
            screenBuilder.getScreen(type: .progress(selectedTime))
        })
//        .onChange(of: appStore.currentRoom, { oldValue, newValue in
//            store.bindRoom(newValue)
//        })
//        .onAppear {
//            store.bindRoom(appStore.currentRoom)
//        }
    }
    
    @ViewBuilder
    private func header() -> some View {
        Color(grandColor)
            .frame(height: safeAreaInsets.top)
            .textureOverlay()
            .onChange(of: store.state.room.image) { oldValue, newValue in
                grandColor = Color.averageTopRowColor(from: UIImage(named: appStore.currentRoom.roomType.image))
            }
    }
    
    @ViewBuilder
    private func roomView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            screenBuilder.getComponent(type: .roomView)
            .textureOverlay()
            .offset(y: minY > 0 ? -minY : 0)
            .scaleEffect(x: minY > 0 ? 1 + minY / 1000 : 1,
                         y: minY > 0 ? 1 + minY / 1000 : 1,
                         anchor: .top)
        }
        .frame(height: 400)
    }
    
    @ViewBuilder
    private func debugConsole() -> some View {
        HStack {
            Button("Room") {
                store.send(.changedRoomType, animation: nil)
            }
            Button("Shelf") {
                store.send(.changedShelfType, animation: nil)
            }
            Button("Plant") {
                store.send(.addRandomPlant, animation: nil)
            }
        }.padding(.vertical, 30)
    }
        
    @ViewBuilder
    private func newPlantSection() -> some View {
        TextureView(insets: .zero) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(appStore.selectedPlant == nil ? "New Plant" : "Upgrade plant")
                            .font(.myTitle(30))
                            .foregroundStyle(.black)
                        
                        NumericText(text: $selectedTime)
                            .foregroundStyle(.black)
                    }
                    .padding(.top, 16)
                    .padding(.leading, 14)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 18) {
                        TextureButton(label: "Start", color: .strokeAcsent1, icon: Image(.iconPlay)) {
                            print("start")
                            isProgress = true
                        }
                        
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15)
                                .foregroundStyle(.black)
                            TagView(tag: Tag(name: "Programming", color: "7C37B5"))
                        }
                    }.padding(.trailing, 14)
                        .padding(.top, 48)
                }
                
                TimePickerView(selectedTime: $selectedTime)
                    .frame(height: 70)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 16)
                    .padding(.top, 28)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 10)
        .padding(.top, 16)
    }
}


fileprivate struct NumericText: View {
    @Binding var text: Int
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            Text("\(text)")
                .font(.myTitle(50))
            Text("min")
                .font(.myTitle(22))
                .padding(.bottom, 7)
        }
    }
}

#Preview {
    screenBuilderMock.getScreen(type: .home)
}
