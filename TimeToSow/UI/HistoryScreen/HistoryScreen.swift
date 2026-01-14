//
//  HistoryScreen.swift
//  TimeToSow
//
//  Created by Nebo on 07.01.2026.
//

import SwiftUI

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

struct HistoryScreen: View {
    
    //    @Environment(\.screenBuilder) var screenBuilder: ScreenBuilder
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.dismiss) var dismiss
    
    @State private var store: HistoryScreenStore
    @State private var screenBuilder: ScreenBuilder
    
    @State private var isShowHeader = true
    
    init(store: HistoryScreenStore, screenBuilder: ScreenBuilder) {
        self.store = store
        self.screenBuilder = screenBuilder
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if !store.state.isCurrentMonth, isShowHeader {
                roomView()
                    .padding(.bottom, 5)
            }
            contentLayer
        }
        .background(.mainBackground)
        .navigationTitle("History")
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(store.state.headerColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Circle()
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .overlay {
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.black)
                            }
                    }
                }.buttonStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    private func header() -> some View {
        Color(.red)
            .frame(height: safeAreaInsets.top)
            .textureOverlay()
    }
    
    @State var isAnimate = false
    var contentLayer: some View {
        HStack(spacing: 0) {
            monthsScrollView()
            ScrollViewReader { proxy in
                ScrollView {
                    Color.clear
                        .frame(height: 1)
                        .id("Top")
                    HStack {
                        statisticsView()
                        Spacer()
                    }
                    monthStatisticSection()
                    tagStatisticsSection()
                    notesHistorySection()
                }
                .onChange(of: store.state.currentRoomId, { oldValue, newValue in
                    isAnimate = true
                    withAnimation {
                        proxy.scrollTo("Top", anchor: .top)
                        isShowHeader = true
                    } completion: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            isAnimate = false
                        }
                    }
                })
                .onScrollGeometryChange(for: CGFloat.self, of: \.contentOffset.y) { offset, _ in
                    if offset > 10, !isAnimate, isShowHeader {
                        isAnimate = true
                        withAnimation(.default) {
                            isShowHeader = false
                        } completion: {
                            isAnimate = false
                        }
                    } else if offset < -130, !isAnimate, !isShowHeader {
                        isAnimate = true
                        withAnimation {
                            isShowHeader = true
                        } completion: {
                            isAnimate = false
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func statisticsView() -> some View {
        TextureView(insets: .init(top: 6, leading: 15, bottom: 6, trailing: 15), texture: Image(.smallTexture1), cornerRadius: 12) {
            HStack(spacing: 0) {
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
    private func notesHistorySection() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("История записей")
                .font(.myTitle(20))
                .foregroundStyle(.black)
                .padding(.bottom, -12)
            RecordsHistoryView(notes: store.state.notes)
        }.padding(.horizontal, 10)
            .padding(.top, 12)
    }
    
    @ViewBuilder
    private func monthStatisticSection() -> some View {
        TextureView(insets: .zero) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(store.state.name)
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
                            .id(store.state.topTag)
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
    
    @ViewBuilder
    private func tagStatisticsSection() -> some View {
        TextureView(insets: .zero) {
            TagStatisticsView(notes: store.state.notes)
        }.padding(.all, 10)
    }
    
    
    @ViewBuilder
    private func roomView() -> some View {
        GeometryReader { proxy in
            screenBuilder.getComponent(type: .roomView(id: store.state.currentRoomId))
                .textureOverlay()
        }
        .frame(height: 400)
    }
    
    @ViewBuilder
    func monthsScrollView() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 7) {
                ForEach(store.state.allRooms) { room in
                    monthCell(text: room.name, id: room.id)
                }
            }
        }.background(Color(hex: "#D7D7D7"))
    }
    
    @ViewBuilder
    func monthCell(text: String, id: UUID) -> some View {
        Button {
            withAnimation {
                store.send(action: .selectRoom(id: id))
            }
        } label: {
            Text(text)
                .foregroundColor(Color.black)
                .padding(10)
                .aspectRatio(contentMode: .fill)
                .rotationEffect(.degrees(-90), anchor: .center)
                .frame(width: 26, height: 150)
                .background( id == store.selectedUserRoomId ? .mainBackground : store.state.getMonthColor(by: id))
                .cornerRadius(5, corners: [.topLeft, .bottomLeft])
        }
    }
}

#Preview {
    NavigationStack {
        screenBuilderMock.getScreen(type: .history)
    }
    
}
