//
//  HomeScreen.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI
import SDWebImageSwiftUI

fileprivate enum L: LocalizedStringKey {
    case newPlantTitle = "HomeScreen.newPlantTitle"
    case updatePlantTitle = "HomeScreen.upgradePlantTitle"
    case startButton = "HomeScreen.startButton"
    case monthStatistic_PlantCount = "HomeScreen.MonthStatistic.plantCountText"
    case monthStatistic_BonusCount = "HomeScreen.MonthStatistic.bonusCountText"
    case monthStatistic_TopPlant = "HomeScreen.MonthStatistic.topPlantText"
    case monthStatistic_TopTag = "HomeScreen.MonthStatistic.topTagText"
    
    var loc: LocalizedStringKey { rawValue }
}

struct HomeScreen: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var selectedTime: Int
    @State private var isProgress = false
    @State private var progressTime: Int?
    @State private var isShowBox = false
    
    private var store: HomeScreenStore
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
                            Image(.deleteAnimation6)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                                .offset(x: 30, y: 20)
                                .onTapGesture {
                                    isShowBox.toggle()
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
            if isShowBox {
                BoxView(plants: store.state.boxPlants, decor: store.state.boxDecor, isShowBox: $isShowBox)
                    .frame(height: UIScreen.main.bounds.height / 2.2)
                    .transition(.move(edge: .bottom))
                    .zIndex(100)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isShowBox)
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
                        Text((store.state.selectedPlant == nil ? L.newPlantTitle : L.updatePlantTitle).loc)
                            .font(.myTitle(28))
                            .foregroundStyle(.black)
                        
                        NumericText(text: $selectedTime)
                            .foregroundStyle(.black)
                    }
                    .padding(.top, 16)
                    .padding(.leading, 14)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 18) {
                        TextureButton(label: L.startButton.loc, color: .strokeAcsent1, icon: Image(.iconPlay)) {
                            print("start")
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
                    
                    lineStatisticView(title: L.monthStatistic_PlantCount.loc,
                                      view: Text(String(store.state.plantCount))
                        .font(.myRegular(14))
                        .foregroundStyle(.black)
                    )
                    
                    lineStatisticView(title: L.monthStatistic_BonusCount.loc,
                                      view: Text("1")
                        .font(.myRegular(14))
                        .foregroundStyle(.black)
                    )
                    
                    if let topPlant = store.state.topPlant {
                        lineStatisticView(title: L.monthStatistic_TopPlant.loc,
                                          view: RarityView(count: topPlant.seed.rarity.starCount + topPlant.pot.rarity.starCount)
                            .frame(height: 12)
                        )
                    }
                    
                    if let topTag = store.state.topTag {
                        lineStatisticView(title: L.monthStatistic_TopTag.loc,
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
    func lineStatisticView(title: LocalizedStringKey, view: some View) -> some View {
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
    //    ContentView()
    screenBuilderMock.getScreen(type: .home)
    //        .environment(\.locale, .init(identifier: "en"))
}

//struct GifView: View, Equatable {
//    static func == (lhs: GifView, rhs: GifView) -> Bool {
//        true
//    }
//
//    let isAnimating: Bool
//
//    var body: some View {
//        AnimatedImage(name: "feature2.gif", isAnimating: .constant(isAnimating))
//            .resizable()
//            .customLoopCount(2)
//            .scaledToFit()
//            .frame(height: 50)
//    }
//}
//
//GifView(isAnimating: isAnimation)
//    .onTapGesture {
//        isAnimation.toggle()
//    }
//
