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
            Image(.sectionBackground)
                .resizable()
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
        .background { LinearGradient(colors: [Color.gray.opacity(1), Color.gray.opacity(1)], startPoint: .top, endPoint: .bottom) }
//        .background(Color.gray)
        .ignoresSafeArea(.all)
        .animation(.easeIn, value: localStore.state)
    }
    
    @ViewBuilder
    func processView() -> some View {
        GeometryReader { proxy in
            VStack {
                HStack{
                    Button { isShowAlert = true }
                label: {
                    Image("iconClose")
                        .resizable()
                        .foregroundColor(.black)
                        .frame(width: 40, height: 40)
                }
                    Spacer()
                }
                .padding(.top, 50)
                .padding(.leading, 30)
                LoopingFramesView(frames: ["updateAnimation1", "updateAnimation2", "updateAnimation3", "updateAnimation4"], speed: 0.5)
                    .frame(width: proxy.size.width * 0.7, height: proxy.size.width * 0.7 * 9 / 12)
                    .padding(.top, 10)
                TimerView(vm: localStore.timerVM)
                progressCircleView()
                Text("do it now")
                    .font(.myDescription(25))
                    .foregroundColor(.black)
                    .padding(.top, 20)
            }
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
        GeometryReader { proxy in
            VStack(spacing: 0) {
                Spacer()
                let newPlant = appStore.getRandomPlant()
                PlantPreview(zoomCoef: 2, plant: newPlant)
                
                Text("Completed!")
                    .font(.myDescription(27))
                    .foregroundColor(.black)
                    .padding(.vertical, 30)
                
                progressCircleView()
                
                Button {
                    dismiss()
                } label: {
                    TextEllipseStrokeView(text: "Place", font: .myButton(30), isSelected: true)
                        .foregroundStyle(Color(UIColor.systemPink))
                        .frame(width: 140, height: 80)
                }
                .padding(.vertical, 30)
                Spacer()
            }.frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    func progressCircleView() -> some View {
        CircleProgressView(progress: localStore.progress)
            .overlay(alignment: .bottom) {
                if localStore.state == .completed {
                    VStack(alignment: .center, spacing: 0) {
                        Text("\(Int(localStore.minutes))")
                        Text("min")
                    }
                    .offset(y: -10)
                    .foregroundColor(.white)
                }
            }
    }
}

#Preview {
    ProgressScreen(minutes: 1)
}
