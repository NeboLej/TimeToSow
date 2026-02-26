//
//  BoxScreen.swift
//  TimeToSow
//
//  Created by Nebo on 25.01.2026.
//

import SwiftUI

struct BoxScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @State var store: BoxScreenStore
    
    @State private var selectedPlant: Plant? {
        willSet {
            if selectedDecor != nil {
                selectedDecor = nil
            }
        }
    }
    @State private var selectedDecor: DecorType? {
        willSet {
            if selectedPlant != nil {
                selectedPlant = nil
            }
        }
    }
    @State private var selection = 0
    
    var body: some View {
        boxView()
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
            .ignoresSafeArea(.all, edges: .bottom)
            .presentationBackground(.mainBackground)
    }
    
    @ViewBuilder
    private func boxView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            VStack {
                HStack {
                    Spacer()
                    Text(Lo.BoxScreen.title)
                        .font(.myTitle(24))
                        .foregroundStyle(.black)
                        .padding(.leading, 30)
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image("iconClose")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
                }
                .padding(.top, 16)
                .padding(.horizontal)
                
                Picker("", selection: $selection) {
                    Text(Lo.BoxScreen.pickerPlants).tag(0)
                    Text(Lo.BoxScreen.pickerDecor).tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                GeometryReader { geo in
                    let columns = 2
                    let width = (geo.size.width - CGFloat(10 * (columns - 1))) / CGFloat(columns)
                    ScrollView {
                        if selection == 0 {
                            if store.state.plants.isEmpty {
                                emptyState(Lo.BoxScreen.emptyStatePlants)
                            } else {
                                MasonryLayout(columns: columns, spacing: 10) {
                                    plantCollection(cellWidth: width)
                                }
                            }
                        } else if selection == 1 {
                            if store.state.decors.isEmpty {
                                emptyState(Lo.BoxScreen.emptyStateDecor)
                            } else {
                                MasonryLayout(columns: columns, spacing: 10) {
                                    decorCollection(cellWidth: width)
                                }
                            }
                        }
                        
                        Spacer(minLength: 30)
                    }.scrollIndicators(.hidden)
                }
                .padding([.horizontal], 16)
            }
            .frame(maxWidth: .infinity)
            .cornerRadius(16, corners: [.topLeft, .topRight])
            .shadow(radius: 8)
        }
    }
    
    @ViewBuilder
    private func plantCollection(cellWidth: CGFloat) -> some View {
        ForEach(store.state.plants) { plant in
            PlantPreview(zoomCoef: 1.5, plant: plant, isShowPlantRating: false, isShowPotRating: false)
                .flatShadow(blur: 5, distanceToLight: 30)
                .frame(width: cellWidth)
                .padding(.vertical, 16)
                .background(.black.opacity(0.1))
                .blur(radius: selectedPlant == plant ? 3 : 0)
                .cornerRadius(16, corners: .allCorners)
                .overlay(content: {
                    if selectedPlant == plant {
                        overlayMenu()
                    }
                })
                .onTapGesture {
                    withAnimation {
                        if selectedPlant == plant {
                            selectedPlant = nil
                        } else {
                            selectedPlant = plant
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    private func decorCollection(cellWidth: CGFloat) -> some View {
        ForEach(store.state.decors) { decor in
            DecorTypePreview(decorType: decor, zoom: 2)
                .shadow(color: .black.opacity(0.8), radius: 4, x: 1, y: 1)
                .frame(width: cellWidth)
                .padding(.vertical, 24)
                .background(.black.opacity(0.1))
                .blur(radius: selectedDecor == decor ? 3 : 0)
                .cornerRadius(16, corners: .allCorners)
                .overlay(content: {
                    if selectedDecor == decor {
                        overlayMenu()
                    }
                })
                .onTapGesture {
                    withAnimation {
                        if selectedDecor == decor {
                            selectedDecor = nil
                        } else {
                            selectedDecor = decor
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    private func emptyState(_ text: String) -> some View {
        Text(text)
            .font(.myTitle(20))
            .multilineTextAlignment(.center)
            .foregroundStyle(.black.opacity(0.6))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
    }
    
    @ViewBuilder
    private func overlayMenu() -> some View {
        VStack {
            Spacer()
            button(label: Lo.BoxScreen.cellMenuInfo) {
                if let selectedPlant {
                    store.send(.infoPlant(selectedPlant))
                } else if let selectedDecor {
                    store.send(.infoDecor(selectedDecor))
                }
            }
            button(label: Lo.BoxScreen.cellMenuOnShelf) {
                if let selectedPlant {
                    store.send(.toShelfPlant(selectedPlant))
                    self.selectedPlant = nil
                } else if let selectedDecor {
                    store.send(.toShelfDecor(selectedDecor))
                    self.selectedDecor = nil
                }
            }
            .padding(.bottom, 8)
        }.padding(.horizontal)
    }
    
    @ViewBuilder
    private func button(label: String, action: @escaping () -> Void, color: Color = .white) -> some View {
        Button(action: action) {
            TextureView(
                insets: .init(top: 6, leading: 18, bottom: 6, trailing: 18),
                texture: Image(.smallTexture1),
                color: color,
                cornerRadius: 50
            ) {
                Text(label)
                    .font(.myNumber(16))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(PressableStyle())
    }
}

#Preview {
//    screenBuilderMock.getScreen(type: .home)
    screenBuilderMock.getScreen(type: .box)
}
