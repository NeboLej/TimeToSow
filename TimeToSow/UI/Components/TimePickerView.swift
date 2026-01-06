//
//  TimePickerView.swift
//  TimeToSow
//
//  Created by Nebo on 18.05.2025.
//

import SwiftUI

struct TimePickerView: View {
    
    @Binding var selectedTime: Int
    @State var minInterval: Int = 1
    @State var maxInterval: Int = 120
    
    @State var pointWidth: CGFloat = 48
    
    @State private var accumulated: CGFloat = 0
    @State var offsetX: CGFloat = 0
    @State var widthInOneTime: CGFloat = 0
    @State var step: Int = 1
    
    var body: some View {
        VStack {
            HStack {
                Text(String(minInterval))
                    .font(.myDescription(20))
                    .foregroundStyle(.black)
                Spacer()
                Text(String(maxInterval))
                    .font(.myDescription(20))
                    .foregroundStyle(.black)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, -15)
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Image(.timePickerMainLine)
                        .resizable()
                        .frame(height: 30)
                        .onAppear {
                            widthInOneTime = (proxy.size.width  - pointWidth) / CGFloat(maxInterval - minInterval)
                            offsetX = widthInOneTime * CGFloat(selectedTime - minInterval)
                            accumulated = offsetX
                        }
                    Image(.timePickerFillLine)
                        .resizable()
                        .frame(height: 30)
                        .mask(alignment: .leading, {
                            Rectangle()
//                                .fill(.red)
                                .frame(width: widthInOneTime * CGFloat(selectedTime - minInterval) + pointWidth / 2 , height: 30)
                        })
   
                    Image(.timePickerPoint)
                        .resizable()
                        .rotationEffect(Angle(degrees: Double(selectedTime) * 5), anchor: .center)
                        .frame(width: pointWidth, height: pointWidth)
                        .offset(x: offsetX)
                        .gesture(DragGesture()
                            .onChanged { value in
                                offsetX = value.translation.width + self.accumulated
                                if offsetX < 0 { offsetX = 0 }
                                else if offsetX > proxy.size.width - pointWidth { offsetX = proxy.size.width - pointWidth }
                                calculateSelectedTime(offsetX)
                            }
                            .onEnded{ value in
                                self.accumulated = offsetX
                            })
                }
            }

        }
    }
    
    func calculateSelectedTime(_ offsetX: CGFloat) {
        selectedTime = ((Int(offsetX / widthInOneTime) + minInterval) / step) * step
    }
}

#Preview {
    @Previewable @State var time: Int = 10
    
    VStack {
        TimePickerView(selectedTime: $time, step: 1)
        Text("\(time)")
    }
}
