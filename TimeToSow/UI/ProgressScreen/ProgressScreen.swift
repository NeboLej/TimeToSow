//
//  ProgressScreen.swift
//  TimeToSow
//
//  Created by Nebo on 23.08.2025.
//

import SwiftUI

struct ProgressScreen: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var store: ProgressScreenStore
    @State var isShowAlert = false
    
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
                switch store.state {
                case .progress:
                    processView()
                case .completed:
                    completedView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .animation(.easeIn, value: store.state)
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
            
            SendTimerView(progress: CGFloat(store.progress))
                .frame(width: 112)
                .padding(.top, 70)
            
            
            TimerView(vm: store.timerVM)
                .padding(.bottom, 8)
                .padding(.top, 45)
            
            Text("Ученые доказали, что дела лучше делаются если не смотреть на экран")
                .multilineTextAlignment(.center)
                .font(.myNumber(20))
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
    func completedView() -> some View {
        VStack(alignment: .center, spacing: 0) {
            if store.newPlant != nil {
                PlantPreview(zoomCoef: 2,
                             plant: store.newPlant!,
                             isShowPlantRating: true,
                             isShowPotRating: true)
                .padding(.top, 120)
            }
            
            Text("Успех!")
                .font(.myNumber(50))
                .foregroundStyle(.black)
                .padding(.top, 45)
                .padding(.bottom, 8)
            
            let seedName = "\(RemoteText.text(store.newPlant?.seed.name ?? ""))"
            let potName = "\(RemoteText.text(store.newPlant?.pot.name ?? ""))"

            Text("Теперь у вас есть \n \(seedName) \(potName)")
                .multilineTextAlignment(.center)
                .font(.myNumber(20))
                .padding(.horizontal, 16)
                .padding(.top, 50)
            
            TextureButton(label: "поместить на полку", color: .strokeAcsent1, icon: nil) {
                store.newPlantToShelf()
                dismiss()
            }.padding(.top, 150)
        }
    }
}

#Preview {
    screenBuilderMock.getScreen(type: .progress(1))
}
