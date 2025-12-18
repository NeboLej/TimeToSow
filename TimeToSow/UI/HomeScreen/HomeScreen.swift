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
    @State private var localStore = HomeScreenLocalStore()
    @State private var isShowMenu: Bool = false
    @State private var isShowEditRoom = false
    @State var selectedPlant: Plant?
    @State var isProgress = false
    
    var body: some View {
        VStack(spacing: 0) {
            header()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    roomView()
                        .zIndex(100)
                        .gesture(TapGesture().onEnded {
                            withAnimation(.easeInOut) {
                                isShowMenu.toggle()
                            }
                        })
                        .overlay(alignment: .trailing) {
                            cityMenu()
                        }
                    
                    if isMovePlant {
                        editPlantSection()
                    } else if selectedPlant != nil {
                        selectPlantSection()
                    } else {
                        newPlantSection()
                    }
#if DEBUG
                    debugConsole()
#endif
                }

            }
            .coordinateSpace(name: "SCROLL")
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
            localStore.bindRoom(appStore.currentRoom)
        }, content: {
            screenBuilder.getScreen(type: .editRoom)
        })
        .fullScreenCover(isPresented: $isProgress, onDismiss: {
            isProgress = false
        }, content: {
            screenBuilder.getScreen(type: .progress(selectedTime))
        })
        .onChange(of: appStore.currentRoom, { oldValue, newValue in
            localStore.bindRoom(newValue)
        })
        .onAppear {
            localStore.bindRoom(appStore.currentRoom)
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
    private func header() -> some View {
        Color(grandColor)
            .frame(height: safeAreaInsets.top)
            .textureOverlay()
            .onChange(of: localStore.currenRoom.roomType.image) { oldValue, newValue in
                grandColor = Color.averageTopRowColor(from: UIImage(named: localStore.currenRoom.roomType.image))
            }
    }
    
    @ViewBuilder
    private func cityMenu() -> some View {
        VStack(alignment: .center, spacing: 25) {
            Button(action: { withAnimation { isShowEditRoom = true } }, label: {
                Image(systemName: "paintbrush")
                    .foregroundColor(.black)
            })
            Button(action: {}, label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.black)
            })
            Button(action: {}, label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.black)
            })
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.67))
        .cornerRadius(20, corners: [.bottomLeft, .topLeft])
        .offset(x: isShowMenu ? 0 : 50, y: -20)
    }
    
    @ViewBuilder
    private func debugConsole() -> some View {
        HStack {
            Button("Room") {
                localStore.bindRoom(appStore.setRandomRoom())
            }
            
            Button("Shelf") {
                localStore.bindRoom(appStore.setRandomShelf())
            }
            
            Button("Plant") {
                localStore.bindRoom(appStore.addRandomPlantToShelf())
            }
        }.padding(.vertical, 30)
    }
    
    @State var isInTargetZone = false
    @State var targetFrame: CGRect = .zero
    @State var isMovePlant = false
    
    @ViewBuilder
    private func selectPlantSection() -> some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Text("Update Plant")
                    .font(.myTitle(30))
                    .padding(.top, 16)
                    .foregroundStyle(.black)
                    .padding(.bottom, 16)
                Spacer()
                Button {
                    withAnimation {
                        selectedPlant = nil
                    }
                } label: {
                    Image("iconClose")
                        .resizable()
                }
                .frame(width: 30, height: 30)
            }
            
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    NumericText(text: $selectedTime)
                        .font(.myTitle(40))
                        .foregroundStyle(.black)
                    
                    Button {
                        print("start")
                    } label: {
                        TextEllipseStrokeView(text: "Start", font: .myButton(30), isSelected: true)
                            .foregroundStyle(Color(UIColor.systemPink))
                            .frame(width: 140, height: 60)
                    }
                }
                Spacer()
                PlantPreview(zoomCoef: 2.0, plant: selectedPlant!)
                    .padding(.bottom, 20)
                Spacer()
            }
            
            TimePickerView(selectedTime: $selectedTime)
                .frame(height: 100)
                .padding(.horizontal, 0)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background {
            Image(.sectionBackground)
                .resizable()
        }
    }
    
    @ViewBuilder
    private func editPlantSection() -> some View {
        HStack(spacing: 16) {
            VStack(spacing: 5) {
                Text("Delete Plant")
                    .font(.myTitle(25))
                    .foregroundStyle(.black)
                    .padding(.bottom, 8)
                LoopingFramesView(frames: ["deleteAnimation1", "deleteAnimation2", "deleteAnimation3", "deleteAnimation4", "deleteAnimation5", "deleteAnimation6"], speed: 0.15)
                    .overlay {
                        if isMovePlant {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(style: StrokeStyle(lineWidth: 4, dash: [12]))
                                .foregroundColor(.strokeAcsent2)
                        }
                    }
            }
            
            VStack(spacing: 5) {
                Text("Update Plant")
                    .font(.myTitle(25))
                    .foregroundStyle(.black)
                    .padding(.bottom, 8)
                LoopingFramesView(frames: ["updateAnimation1", "updateAnimation2", "updateAnimation3", "updateAnimation4"], speed: 0.5)
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    self.targetFrame = geometry.frame(in: .global)
                                }
                                .onChange(of: geometry.frame(in: .global)) { _ , newFrame in
                                    self.targetFrame = newFrame
                                }
                        }
                    )
                    .overlay {
                        if isMovePlant {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(style: StrokeStyle(lineWidth: 4, dash: [12]))
                                .foregroundColor(.strokeAcsent1)
                            
                        }
                    }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.all, 16)
        .background {
            Image(.sectionBackground)
                .resizable()
        }
    }
    
    @ViewBuilder
    private func newPlantSection() -> some View {
        TextureView(insets: .zero) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("New Plant")
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
    HomeScreen()
}
