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
    @State private var activityType: Int = 0
    @State private var selectedTime: Int = 50
    @State private var isShowEditRoom = false
    @State private var isProgress = false
    
    private var store: HomeScreenStore
    
    init(store: HomeScreenStore) {
        self.store = store
    }
    
    var body: some View {
        let coordinator = Bindable(appStore.appCoordinator)
        
        VStack(spacing: 0) {
            header()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    roomView()
                        .zIndex(100)
                    
                    HStack {
                        statisticsView()
                        Spacer()
                        menuView()
                    }
                    
                    newPlantSection()
                    monthStatisticSection()
                    tagStatisticsSection()
                    
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
        .sheet(item: coordinator.activeSheet, onDismiss: {
            print("dismiss")
        }, content: { screenType in
            screenBuilder.getScreen(type: screenType)
        })
        .fullScreenCover(isPresented: $isProgress, onDismiss: {
            isProgress = false
        }, content: {
            screenBuilder.getScreen(type: .progress(selectedTime))
        })
    }
    
    @ViewBuilder
    private func header() -> some View {
        Color(store.state.headerColor)
            .frame(height: safeAreaInsets.top)
            .textureOverlay()
    }
    
    @ViewBuilder
    private func statisticsView() -> some View {
        TextureView(insets: .init(top: 6, leading: 15, bottom: 6, trailing: 15), texture: Image(.smallTexture1), cornerRadius: 12) {
            HStack(spacing: 0) {
                DrawText(text: "\(store.state.plantCount)",
                         font: UIFont.myTitle(18),
                         duration: 1)
                .foregroundStyle(.black)
                Image(.seedIcon)
                    .padding(.trailing, 20)
                DrawText(text: store.state.loggedMinutesCount.toHoursAndMinutes(),
                         font: UIFont.myTitle(18),
                         duration: 1)
                .foregroundStyle(.black)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    private func  menuView() -> some View {
        HStack(spacing: 6) {
            menuElement(colorHex: "D17474", icon: "square.and.arrow.up")
            menuElement(colorHex: "7482D1", icon: "info.circle")
            menuElement(colorHex: "6E916A", icon: "paintbrush")
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    private func menuElement(colorHex: String, icon: String) -> some View {
        TextureView(insets: .zero, texture: Image(.smallTexture1), color: Color(hex: colorHex),
                    cornerRadius: 16) {
            Circle()
                .fill(Color.clear)
                .frame(height: 32)
                .overlay {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)
                        .foregroundStyle(.white)
                }
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
                store.send(.addRandomPlant)
            }
            Button("Note") {
                store.send(.addRandomNote)
            }
        }
    }
    
    @ViewBuilder
    private func newPlantSection() -> some View {
        TextureView(insets: .zero) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text(store.state.selectedPlant == nil ? "New Plant" : "Upgrade plant")
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
    }
    
    @ViewBuilder
    private func tagStatisticsSection() -> some View {
        TextureView(insets: .zero) {
            TagStatisticsView(notes: store.state.allNotes)
        }.padding(.all, 10)
    }
    
    @ViewBuilder
    private func monthStatisticSection() -> some View {
        TextureView(insets: .zero) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(store.state.roomName)
                        .font(.myTitle(28))
                        .foregroundStyle(.black)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                    
                    lineStatisticView(title: "Plants count",
                                      view: Text(String(store.state.plantCount))
                        .font(.myRegular(14))
                        .foregroundStyle(.black)
                    )
                    
                    lineStatisticView(title: "Bonuses count",
                                      view: Text("1")
                        .font(.myRegular(14))
                        .foregroundStyle(.black)
                    )
                    
                    if let topPlant = store.state.topPlant {
                        lineStatisticView(title: "Top Plant",
                                          view: RarityView(count: topPlant.seed.rarity.starCount + topPlant.pot.rarity.starCount)
                            .frame(height: 12)
                        )
                    }
                    
                    if let topTag = store.state.topTag {
                        lineStatisticView(title: "Top tag",
                                          view: TagView(tag: topTag)
                        )
                    }
                    
                    Spacer()

                }
                Spacer()
                if let topPlant = store.state.topPlant {
                    let height = topPlant.pot.height + topPlant.seed.height
                    let width = topPlant.pot.width + topPlant.seed.width
                    
                    PlantPreview(zoomCoef: (height >= 100 || width >= 100) ? 1 : 2, plant: topPlant)
                        .padding(.vertical, 40)
                        .id(store.state.topPlant)
                    
                }
            }.padding(.horizontal, 14)
            
        }.padding([.horizontal, .top], 10)
    }
    
    
    @ViewBuilder
    func lineStatisticView(title: String, view: some View) -> some View {
        HStack {
            Text(title)
                .font(.myRegular(14))
                .foregroundStyle(.black)
            Spacer()
            view
        }
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

var tmpSeed = Seed(name: "qwe",
                   availavlePotTypes: PotType.allCases,
                   image: "seed21",
                   height: 32,
                   rarity: .common)

#Preview {
    screenBuilderMock.getScreen(type: .home)
}
