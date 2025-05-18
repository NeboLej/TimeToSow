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
    
    var body: some View {
        ZStack {
            ScrollView {
                ShelfView(shelf: appStore.currentShelf)
                newPlantSection()
                    .offset(y: -20)
                Group {
                    Rectangle()
                        .frame(height: 300)
                    Rectangle()
                        .frame(height: 100)
                }
                
                .cornerRadius(20)
                .padding(.horizontal, 8)
                .offset(y: -20)
            }
            .background(.gray)
        }.ignoresSafeArea(.all, edges: .top)
    }
    
    @ViewBuilder
    func newPlantSection() -> some View {
        
        VStack {
            HStack(spacing: 0) {
                VStack {
                    Text("New Plant")
                        .font(.system(size: 30))
                        .padding(.top, 24)
                    Spacer()
                    Text("\(selectedTime) min")
                        .font(.system(size: 30))
                    Spacer()
                    Button {
                        print("start")
                    } label: {
                        Text("Start")
                            .font(.system(size: 30))
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
            TimePickerView(selectedTime: $selectedTime)
                .frame(height: 100)
                .padding(.horizontal, 8)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background {
            Image(.sectionBackground)
                .resizable()
        }
    }
}

#Preview {
    HomeScreen()
}
