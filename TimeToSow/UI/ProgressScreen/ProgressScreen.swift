//
//  ProgressScreen.swift
//  TimeToSow
//
//  Created by Nebo on 23.08.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProgressScreen: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var store: ProgressScreenStore
    @State private var isShowAlert = false
    @State private var progress: CGFloat = 0
    
    init(store: ProgressScreenStore) {
        self.store = store
    }
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                Color(hex: "E6FBFF")
                
                Group {
                    Image(.imageCloud)
                        .resizable()
                        .offset(x: proxy.size.width * 0.75, y: proxy.size.height * 0.05)
                    
                    Image(.imageCloud)
                        .resizable()
                        .offset(x: proxy.size.width * -0.1, y: proxy.size.height * 0.25)
                    
                    Image(.imageCloud)
                        .resizable()
                        .offset(x: 0, y: proxy.size.height * 0.67)
                    
                    Image(.imageCloud)
                        .resizable()
                        .offset(x: proxy.size.width * 0.68, y: proxy.size.height * 0.83)
                }
                .aspectRatio(contentMode: .fit)
                .frame(width: 140)
                .opacity(0.4)
                
            }
            .textureOverlay(opacity: 0.3)
            
            VStack {
                switch store.state.state {
                case .progress:
                    processView()
                case .completed(let plant):
                    completedView(plant: plant)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .animation(.easeIn, value: store.state.state)
        .navigationBarBackButtonHidden()
        .onAppear {
            store.send(.startProgress)
        }
    }
    
    @ViewBuilder
    func processView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                Button {
                    isShowAlert = true
                } label: {
                    Image("iconClose")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                }
                Spacer()
            }
            .padding(.top, 50)
            .padding(.leading, 20)
            
            SendTimerView(progress: progress)
                .frame(width: 112)
                .padding(.top, 70)
            
            TimerView(startDate: store.state.startDate, minutes: store.state.minutes, onSecondsChange: { second in
                calcProgress(newValue: second)
            }, onFinish: { isFinish in
                store.send(.finishProgress)
            })
            .padding(.bottom, 8)
            .padding(.top, 45)
            
            Text("Ученые доказали, что дела лучше делаются если не смотреть на экран")
                .multilineTextAlignment(.center)
                .font(.myNumber(20))
                .foregroundStyle(.black)
                .padding(.horizontal, 16)
                .padding(.top, 50)
            
            Spacer()
        }
        .alert("При закрытии этого экрана таймер будет остановлен", isPresented: $isShowAlert) {
            Button(role: .destructive) {
                store.send(.stopProgress)
                dismiss()
            } label: {
                Text("Закрыть")
            }
            Button(role: .cancel) { } label: {
                Text("Остаться")
            }
        }
    }
    
    @ViewBuilder
    func completedView(plant: Plant) -> some View {
        VStack(alignment: .center, spacing: 0) {
            if let upgradePlant = store.state.upgradedPlant {
                HStack {
                    let oldPlantZoomCoef = upgradePlant.seed.width > 70 ? 1.5 : 2
                    let newPlantZoomCoef = plant.seed.width > 70 ? 1.5 : 2
                    let zoom = min(oldPlantZoomCoef, newPlantZoomCoef)
                    Spacer()
                    PlantPreview(zoomCoef: zoom,
                                 plant: upgradePlant,
                                 isShowPlantRating: true,
                                 isShowPotRating: true)
                    
                    AnimatedImage(name: "ugradeAnimation.gif")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .padding(.horizontal, 16)
                    
                    PlantPreview(zoomCoef: zoom,
                                 plant: plant,
                                 isShowPlantRating: true,
                                 isShowPotRating: true)
                    Spacer()
                }
                .padding(.top, 120)
            } else {
                PlantPreview(zoomCoef: 2,
                             plant: plant,
                             isShowPlantRating: true,
                             isShowPotRating: true)
                .padding(.top, 120)
            }
            
            Text("Успех!")
                .font(.myNumber(50))
                .foregroundStyle(.black)
                .padding(.top, 45)
                .padding(.bottom, 8)
            
            let seedName = "\(RemoteText.text(plant.seed.name))"
            let potName = "\(RemoteText.text(plant.pot.name))"

            Text("Теперь у вас есть \n \(seedName) \(potName)")
                .multilineTextAlignment(.center)
                .font(.myNumber(20))
                .foregroundStyle(.black)
                .padding(.horizontal, 16)
                .padding(.top, 50)
            
            TextureButton(label: "поместить на полку", color: .strokeAcsent1, icon: nil) {
                store.send(.plantToShelf)
                dismiss()
            }.padding(.top, 150)
        }
    }
    
    private func calcProgress(newValue: Int) {
        progress = 1.0 - ((100.0 / CGFloat((store.state.minutes * 60)) * CGFloat(newValue))) / 100.0
    }
}

#Preview {
    screenBuilderMock.getScreen(type: .progress(TaskModel(id: UUID(), startTime: Date(), time: 1, tag: Tag(id: UUID(), stableId: "sss", name: "ff", color: "", isDeleted: false), plant: plant1)))
}

fileprivate let plant1 = Plant(id: UUID(), rootRoomID: UUID(),
                   seed: DefaultModels.seeds[9],
                   pot: DefaultModels.pots[22],
                   description: "",
                   offsetY: 0,
                   offsetX: 0,
                   isOnShelf: true,
                   dateCreate: Date(),
                   notes: [])
