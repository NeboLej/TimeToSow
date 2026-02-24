//
//  HomeScreen.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI

struct HomeScreen: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var selectedTime: Int
    @State private var progressTime: Int?
    
    @State private var store: HomeScreenStore
    private var screenBuilder: ScreenBuilder
    
    init(store: HomeScreenStore, screenBuilder: ScreenBuilder) {
        self.store = store
        self.screenBuilder = screenBuilder
        selectedTime = 50
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(spacing: 0) {
                header()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ZStack(alignment: .bottomLeading) {
                            roomView()
                                .id(store.state.room)
                            Image(.deleteAnimation6)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                                .offset(x: 30, y: 20)
                                .onTapGesture {
                                    store.send(.toBoxScreen)
                                }
                        }.zIndex(100)
                        
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
    }
    
    @State private var disableRootAnimation = true
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
                         font: UIFont.myNumber(18),
                         duration: 1)
                .foregroundStyle(.black)
                Image(.seedIcon)
                    .padding(.trailing, 20)
                DrawText(text: store.state.loggedMinutesCount.toHoursAndMinutes(),
                         font: UIFont.myNumber(18),
                         duration: 1)
                .foregroundStyle(.black)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 12)
    }
    
    @ViewBuilder
    private func menuView() -> some View {
        HStack(spacing: 6) {
            menuElement(colorHex: "D17474", icon: "plus")
                .onTapGesture {
                    store.send(.toChallengeScreen)
                }
            menuElement(colorHex: "D17474", icon: "square.and.arrow.up")
                .onTapGesture {
                    store.send(.toDebugScreen)
                }
            menuElement(colorHex: "7482D1", icon: "info.circle")
                .onTapGesture {
                    store.send(.toHistoryScreen)
                }
            menuElement(colorHex: "6E916A", icon: "paintbrush")
                .onTapGesture {
                    store.send(.toEditRoomScreen)
                }
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
            screenBuilder.getComponent(type: .roomView(id: nil))
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
            Button("Plant") {
                store.send(.addRandomPlant)
            }
            Button("Note") {
                store.send(.addRandomNote)
            }
        }.padding(.bottom, 50)
    }
    
    @ViewBuilder
    private func newPlantSection() -> some View {
        TextureView(insets: .zero) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text((store.state.selectedPlant == nil ? Lo.HomeScreen.newPlantTitle : Lo.HomeScreen.updatePlantTitle))
                            .font(.myTitle(28))
                            .foregroundStyle(.black)
                        
                        NumericText(text: $selectedTime)
                            .foregroundStyle(.black)
                    }
                    .padding(.top, 16)
                    .padding(.leading, 14)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 18) {
                        TextureButton(label: Lo.Button.start, color: .strokeAcsent1, icon: Image(.iconPlay)) {
                            store.send(.toProgressScreen(time: selectedTime))
                        }
                        
                        if store.state.selectedTag != nil {
                            HStack(spacing: 10) {
                                TagView(tag: store.state.selectedTag!)
                                    .id(store.state.selectedTag)
                                Image(systemName: "pencil.line")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16)
                                    .foregroundStyle(.black)
                            }.onTapGesture {
                                store.send(.toTagsScreen)
                            }
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
                    
                    lineStatisticView(title: Lo.HomeScreen.monthStatistic_PlantCount,
                                      view: Text(String(store.state.plantCount))
                        .font(.myRegular(14))
                        .foregroundStyle(.black)
                    )
                    
                    lineStatisticView(title: Lo.HomeScreen.monthStatistic_BonusCount,
                                      view: Text(String(store.state.bonusCount))
                        .font(.myRegular(14))
                        .foregroundStyle(.black)
                    )
                    
                    if let topPlant = store.state.topPlant {
                        lineStatisticView(title: Lo.HomeScreen.monthStatistic_TopPlant,
                                          view: RarityView(count: topPlant.seed.rarity.starCount + topPlant.pot.rarity.starCount)
                            .frame(height: 12)
                        )
                    }
                    
                    if let topTag = store.state.topTag {
                        lineStatisticView(title: Lo.HomeScreen.monthStatistic_TopTag,
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
                .font(.myNumber(50))
                .opacity(0.8)
            Text(TimeLocalized.minute.loc)
                .font(.myTitle(22))
                .padding(.bottom, 7)
        }
    }
}

var tmpSeed = Seed(name: "qwe",
                   image: "seed33",
                   height: 50,
                   rarity: .epic)

var tmpPot = Pot(name: "aeded",
                 image: "pot25",
                 height: 27,
                 rarity: .common)

#Preview {
    screenBuilderMock.getScreen(type: .home)
            .environment(\.locale, .init(identifier: "en"))
}
