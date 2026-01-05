//
//  ProgressScreen.swift
//  TimeToSow
//
//  Created by Nebo on 23.08.2025.
//

import SwiftUI

struct ProgressScreen: View {
    
    @Environment(\.appStore) var appStore: AppStore
    @Environment(\.dismiss) var dismiss
    
    @State private var localStore: ProgressScreenLocalStore
    @State var isShowAlert = false
    
    init(minutes: Int) {
        localStore = ProgressScreenLocalStore(minutes: minutes)
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
                switch localStore.state {
                case .progress:
                    processView()
                case .completed:
                    completedView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .animation(.easeIn, value: localStore.state)
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
            
            SendTimerView(progress: CGFloat(localStore.progress))
                .frame(width: 112)
                .padding(.top, 70)
            
            
            TimerView(vm: localStore.timerVM)
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
                dismiss()
                //                vm.close()
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
            if localStore.newPlant != nil {
                PlantPreview(zoomCoef: 2,
                             plant: localStore.newPlant!,
                             isShowPlantRating: true,
                             isShowPotRating: true)
                .padding(.top, 120)
            }
            
            Text("Успех!")
                .font(.myNumber(50))
                .foregroundStyle(.black)
                .padding(.top, 45)
                .padding(.bottom, 8)
            
            let seedName = "\(RemoteText.text(localStore.newPlant?.seed.name ?? ""))"
            let potName = "\(RemoteText.text(localStore.newPlant?.pot.name ?? ""))"

            Text("Теперь у вас есть \n \(seedName) \(potName)")
                .multilineTextAlignment(.center)
                .font(.myNumber(20))
                .padding(.horizontal, 16)
                .padding(.top, 50)
            
            TextureButton(label: "поместить на полку", color: .strokeAcsent1, icon: nil) {
                print("")
            }.padding(.top, 150)
        }
    }
}

#Preview {
    ProgressScreen(minutes: 1)
}
