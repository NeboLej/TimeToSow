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
    @State var isShowMenu: Bool = false
    @State var isShowEditRoom = false
    
    var body: some View {
        ZStack {
            ScrollView {
                RoomView(room: $localStore.currenRoom)
                    .gesture(TapGesture().onEnded {
                        withAnimation(.easeInOut) {
                            isShowMenu.toggle()
                        }
                    })
                    .overlay(alignment: .trailing) {
                        cityMenu()
                    }
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
        .sheet(isPresented: $isShowEditRoom, onDismiss: {
            localStore.bindRoom(appStore.currentRoom)
        }, content: {
            screenBuilder.getScreen(type: .editRoom)
        })
        .onAppear {
            localStore.bindRoom(appStore.currentRoom)
        }
        
    }
    
    @ViewBuilder
    private func cityMenu() -> some View {
        VStack(alignment: .center, spacing: 25) {
            Button(action: { withAnimation { isShowEditRoom = true } }, label: {
                Image(systemName: "paintbrush")
                    .foregroundColor(.black)
            } )
            Button(action: {}, label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.black)
            } )
            Button(action: {}, label: {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.black)
            } )
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
        .background(Color.white.opacity(0.67))
        .cornerRadius(20, corners: [.bottomLeft, .topLeft])
        .offset(x: isShowMenu ? 0 : 50, y: -20)
    }
    
    @ViewBuilder
    func debugConsole() -> some View {
        HStack {
            Button("Room") {
                localStore.bindRoom(appStore.setRandomRoom())
            }
            
            Button("Shelf") {
                localStore.bindRoom(appStore.setRandomShelf())
            }
            
            Button("Plant") {
                localStore.bindRoom(appStore.addRandomPlantToShelf())
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
