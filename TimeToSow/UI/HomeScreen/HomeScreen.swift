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
            .background(grandColor.opacity(0.5))
        }
        .ignoresSafeArea(.all, edges: .top)
        .sheet(isPresented: $isShowEditRoom, onDismiss: {
            localStore.bindRoom(appStore.currentRoom)
        }, content: {
            screenBuilder.getScreen(type: .editRoom)
        })
        .onAppear {
            localStore.bindRoom(appStore.currentRoom)
        }
        
    }
    
    @ViewBuilder
    private func roomView() -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("SCROLL")).minY
            
            RoomView(room: $localStore.currenRoom,
                     plantEditorDelegate: self)
            .offset(y: minY > 0 ? -minY : 0)
            .scaleEffect(x: minY > 0 ? 1 + minY / 1000 : 1,
                         y: minY > 0 ? 1 + minY / 1000 : 1,
                         anchor: .top)
        }
        .frame(height: 400)
    }
    
    @ViewBuilder
    private func header() -> some View {
        HStack {
            Spacer()
        }
        .frame(height: safeAreaInsets.top )
        .background(grandColor)
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
            } )
            Button(action: {}, label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.black)
            } )
            Button(action: {}, label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.black)
            } )
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
                selectedPlantPreview(plant: selectedPlant!)
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
        VStack(spacing: 0) {
            Text("New Plant")
                .font(.myTitle(30))
                .padding(.top, 16)
                .foregroundStyle(.black)
            HStack(spacing: 0) {
                VStack {
                    NumericText(text: $selectedTime)
                        .font(.myTitle(40))
                        .foregroundStyle(.black)
                    Button {
                        print("start")
                    } label: {
                        TextEllipseStrokeView(text: "Start", font: .myButton(30), isSelected: true)
                            .foregroundStyle(Color(UIColor.systemPink))
                            .frame(width: 140, height: 20)
                    }
                }
                Spacer()
                Image(ImageResource.plantActivity)
                    .offset(x: 10)
            }
            .padding(.bottom, 8)
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
    
    
    private let zoomCoef: CGFloat = 2.0
    @ViewBuilder
    private func selectedPlantPreview(plant: Plant) -> some View {
        
        let offetX = ((plant.seed.rootCoordinateCoef?.x ?? 0) * CGFloat(plant.seed.height)
                      + (plant.pot.anchorPointCoefficient?.x ?? 0) * CGFloat(plant.pot.height)) * zoomCoef
        let offsetY = ((plant.seed.rootCoordinateCoef?.y ?? 0) * CGFloat(plant.seed.height)
                       + (plant.pot.anchorPointCoefficient?.y ?? 0) * CGFloat(plant.pot.height)) * zoomCoef
        
        VStack(alignment: .center, spacing: 0) {
            Image(plant.seed.image)
                .resizable()
                .scaledToFit()
                .frame(height: CGFloat(plant.seed.height) * zoomCoef)
                .offset(x: offetX,
                        y: offsetY)
                .zIndex(10)
            Image(plant.pot.image)
                .resizable()
                .scaledToFit()
                .frame(height: CGFloat(plant.pot.height) * zoomCoef)
        }
        .offset(x: 0, y: -offsetY/1.3)
    }
}


fileprivate struct NumericText: View {
    @Binding var text: Int
    
    var body: some View {
        Text("\(text) min")
    }
}

#Preview {
    HomeScreen()
}
