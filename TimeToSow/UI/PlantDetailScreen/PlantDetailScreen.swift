//
//  PlantDetailScreen.swift
//  TimeToSow
//
//  Created by Nebo on 21.12.2025.
//

import SwiftUI

fileprivate enum L: LocalizedStringKey {
    case desctiprionTitle = "PlantDetailScreen.descriptionTitle"
    case recordsHistoryTitle = "PlantDetailScreen.recordsHistoryTitle"
    case editButton = "PlantDetailScreen.editButton"
    case returnToShelfButton = "PlantDetailScreen.returnToShelfButton"
    case removeFromShelfButton = "PlantDetailScreen.removeFromShelfButton"
    case deleteButton = "PlantDetailScreen.deleteButton"
    
    var loc: LocalizedStringKey { rawValue }
}

struct PlantDetailScreen: View {
    
    @State var store: PlantDetailScreenStore
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            let plant = store.state.plant
            VStack(spacing: 0) {
                headerView()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        let name = [RemoteText.text(plant.seed.name), RemoteText.text(plant.pot.name)].joined(separator: " ")
                        titleLabel(Text(name))
                            .foregroundStyle(.black)
                            .padding(.all, 10)
                        
                        HStack(alignment: .top) {
                            statisticsView()
                            Spacer()
                            PlantPreview(zoomCoef: plant.seed.height + plant.pot.height > 100 ? 1.5 : 2.5,
                                         plant: plant,
                                         isShowPlantRating: true,
                                         isShowPotRating: true)
                            .padding(.trailing, 14)
                            .padding(.vertical, 20)
                        }
                        if !plant.description.isEmpty {
                            titleLabel(Text(L.desctiprionTitle.loc))
                                .padding(.horizontal, 10)
                                .padding(.top, 10)
                            
                            Text(plant.description)
                                .font(.myDescription(14))
                                .foregroundStyle(.black)
                                .padding(.horizontal, 10)
                                .padding(.top, 8)
                        }
                        
                        tagStatisticsSection()
                            .padding(.top, 10)
                            .shadow(color: .black.opacity(0.2), radius: 2, x: -1, y: -1)
                        
                        titleLabel(Text(L.recordsHistoryTitle.loc))
                            .foregroundStyle(.black)
                            .padding(.bottom, -6)
                            .padding(.horizontal, 10)
                            .padding(.top, 20)
                        
                        RecordsHistoryView(notes: plant.notes)
                            .padding(.horizontal, 10)
                            .padding(.bottom, 100)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            menuView()
                .padding()
            
        }.background(.mainBackground)
        
    }
    
    @ViewBuilder
    private func titleLabel(_ text: Text) -> some View {
        text
            .font(.myTitle(20))
            .foregroundStyle(.black)
    }
    
    @ViewBuilder
    func headerView() -> some View {
        HStack(alignment: .center) {
            ForEach(0..<10) { _ in
                Circle()
                    .frame(width: 14, height: 14)
                    .foregroundStyle(.mainBackground)
            }
            .padding(8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        .background(.strokeAcsent1)
    }
    
    @ViewBuilder
    private func statisticsView() -> some View {
        TextureView(insets: .init(top: 6, leading: 15, bottom: 6, trailing: 15),
                    texture: Image(.smallTexture1), cornerRadius: 12) {
            DrawText(text: store.state.plant.time.toHoursAndMinutes(),
                     font: UIFont.myNumber(18),
                     duration: 1)
            .foregroundStyle(.black)
        }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
    }
    
    @ViewBuilder
    private func tagStatisticsSection() -> some View {
        TextureView(insets: .zero) {
            TagStatisticsView(notes: store.state.plant.notes)
        }.padding(.all, 10)
    }
    
    @State private var isMenuOpen: Bool = false
    
    @ViewBuilder
    private func menuView() -> some View {
        HStack {
            TextureView(insets: .zero, color: .yellow, cornerRadius: 29) {
                VStack(spacing: isMenuOpen ? 10 : 3) {
                    ForEach(0..<3, id: \.self) { _ in
                        Circle()
                            .frame(width: 5, height: 5)
                            .foregroundStyle(.black)
                    }
                }.frame(width: 58, height: isMenuOpen ? 130 : 58)
                    .background(.white.opacity(0.01))
                    .onTapGesture {
                        withAnimation {
                            Vibration.light.vibrate()
                            isMenuOpen.toggle()
                        }
                    }
            }
            if isMenuOpen {
                VStack(alignment: .leading, spacing: 12) {
                    
                    menuElement(L.editButton.loc, color: Color(hex: "DDFFB7")) {}
                    menuElement(store.state.plant.isOnShelf ? L.removeFromShelfButton.loc : L.returnToShelfButton.loc, color: Color(hex: "C9F3FF")) {
                        store.send(.changeShelfVisibility)
                        dismiss()
                    }
                    menuElement(L.deleteButton.loc, color: Color(hex: "FFC8C8")) {}
                }
            }
        }
    }
    
    @ViewBuilder
    private func menuElement(_ text: LocalizedStringKey, color: Color, _ action: @escaping ()->()) -> some View {
        Button {
            action()
        } label: {
            TextureView(insets: .init(top: 4, leading: 6, bottom: 4, trailing: 8), texture: Image(.smallTexture1), color: color, cornerRadius: 0) {
                Text(text)
                    .font(.myTitle(16))
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    screenBuilderMock.getScreen(type: .plantDetails(Plant(rootRoomID: UUID(),
                                                          seed: Seed(name: "seed1.name",
                                                                     image: "seed23",
                                                                     height: 45,
                                                                     rarity: .common),
                                                          pot: Pot(name: "pot1.name",
                                                                   image: "pot21",
                                                                   height: 24,
                                                                   rarity: .common),
                                                          description: "jasdkjn aksnd ajsdnkan kjndknakj dna",
                                                          offsetY: 200,
                                                          offsetX: 200,
                                                          isOnShelf: true,
                                                          notes: [
                                                           Note(date: Date().getOffsetDate(-3), time: 100, tag: Tag(name: "Name", color: "#3D90D9")),
                                                           Note(date: Date(), time: 70, tag: Tag(name: "Name2", color: "#13D0D9"))
                                                          ]
                                                         )))
}
