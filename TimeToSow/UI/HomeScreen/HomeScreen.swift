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
    @State var selectedTime: Int = 10
    
    var body: some View {
        ZStack {
            ScrollView {
                ShelfView(shelf: appStore.currentShelf)
                newPlantSection()
                    .offset(y: -20)
                Group {
                    
//                        .frame(height: 220)
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
            HStack {
                VStack {
                    Text("New Plant")
                    Text("\(selectedTime) min")
                    Button {
                        print("start")
                    } label: {
                        Text("Start")
                    }
                }
                VStack {
                    activityPicker()
                        .padding(.horizontal, 30)
                    Image(ImageResource.plantActivity)
                        .offset(x: 10)
                }
                .padding(.vertical, 16)
            }
            TimePickerView(selectedTime: $selectedTime)
                .frame(height: 100)
                .padding(.horizontal, 8)
        }
        .frame(maxWidth: .infinity)
        .background {
            Image(.sectionBackground)
                .resizable()
        }
        
//        Rectangle()
//            .frame(height: 320)
//            .overlay {
//                Image(.sectionBackground)
//                    .resizable()
//            }
        
//        Image(.sectionBackground)
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .background(.black.opacity(0.5))
            
    }
    
    @ViewBuilder
    private func activityPicker() -> some View {
        Picker(selection: $activityType) {
            Text("build").tag(0)
            Text("greening").tag(1)
        } label: { }
            .pickerStyle(.segmented)
            .onAppear {
                UISegmentedControl.appearance().backgroundColor = .white
                UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.blue)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 10)], for: .normal)
                UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            }
    }
    
}

#Preview {
    HomeScreen()
}
