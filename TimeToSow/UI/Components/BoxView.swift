//
//  BoxView.swift
//  TimeToSow
//
//  Created by Nebo on 25.01.2026.
//

import SwiftUI

struct BoxView: View {
    
    var plants: [Plant]
    var decor: [Decor]
    @Binding var isShowBox: Bool
    
    let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 8)
    ]
    @State private var selection = 0
    
    var body: some View {
        boxView()
    }

    @ViewBuilder
    private func boxView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            VStack {
                HStack {
                    Spacer()
                    Text("Коробка")
                        .font(.myTitle(24))
                        .foregroundStyle(.black)
                        .padding(.leading, 30)
                    Spacer()
                    Button {
                        isShowBox = false
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
                    Text("Растения").tag(0)
                    Text("Декор").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 8) {
                        if selection == 0 {
                            ForEach(plants) {
                                PlantPreview(zoomCoef: 1.5, plant: $0, isShowPlantRating: false, isShowPotRating: false)
                            }
                        } else if selection == 1 {
                            ForEach(decor) {
                                DecorPreview(zoomCoef: 2.5, decor: $0)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
            .frame(maxWidth: .infinity)
            .background(.mainBackground)
            .cornerRadius(16, corners: [.topLeft, .topRight])
            .shadow(radius: 8)
        }
    }
    
}
