//
//  HomeScreen.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import SwiftUI

struct HomeScreen: View {
    
    @Environment(\.appStore) var appStore: AppStore
    @Environment(\.screenBuilder) var screenBuilder: ScreenBuilder
    
    @State var activityType: Int = 0
    @State var selectedTime: Int = 50
    @State var selectedElement: PickerElement = .new
    @State var localStore = HomeScreenLocalStore()
    
    var body: some View {
        ZStack {
            ScrollView {
                RoomView(room: $localStore.currenRoom)
#if DEBUG
                debugConsole()
#endif
                newPlantSection()
                    .offset(y: -20)
                Group {
                    Rectangle()
                        .frame(height: 300)
                        .foregroundStyle(.black)
                    Rectangle()
                        .frame(height: 100)
                        .foregroundStyle(.black)
                }
                
                .cornerRadius(20)
                .padding(.horizontal, 8)
                .offset(y: -20)
            }
            .background(.gray)
        }
        .ignoresSafeArea(.all, edges: .top)
        .onAppear {
            localStore.setCurrentRoom(room: appStore.currentRoom)
        }
    }
    
    @ViewBuilder
    func debugConsole() -> some View {
        HStack {
            Button("Room") {
                localStore.setCurrentRoom(room: appStore.setRandomRoom()) 
            }
            
            Button("Shelf") {
                localStore.setCurrentRoom(room: appStore.setRandomShelf())
            }
            
            Button("Plant") {
                
            }
        }.padding(.bottom, 20)
    }
    
    @ViewBuilder
    func newPlantSection() -> some View {
        VStack {
            HStack(spacing: 0) {
                VStack {
                    Text("New Plant")
                        .font(.myTitle(40))
                        .padding(.top, 24)
                        .foregroundStyle(.black)
                    Spacer()
                    NumericText(text: $selectedTime)
                        .font(.myTitle(40))
                        .foregroundStyle(.black)
                    Spacer()
                    Button {
                        print("start")
                    } label: {
                        TextEllipseStrokeView(text: "Start", font: .myButton(30), isSelected: true)
                            .foregroundStyle(Color(UIColor.systemPink))
                            .frame(width: 140, height: 60)
                    }
                }
                VStack {
                    SelectPickerView(selectedElement: $selectedElement)
                        .padding(.horizontal, 0)
                    Image(ImageResource.plantActivity)
                        .offset(x: 10)
                }
                .padding(.all, 16)
            }
            .padding(.bottom, 20)
            TimePickerView(selectedTime: $selectedTime)
                .frame(height: 100)
                .padding(.horizontal, 0)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background {
            Image(.sectionBackground)
                .resizable()
        }
    }
}


fileprivate struct NumericText: View {
    @Binding var text: Int
    
    var body: some View {
        Text("\(text) min")
    }
}

#Preview {
    HomeScreen()
}
