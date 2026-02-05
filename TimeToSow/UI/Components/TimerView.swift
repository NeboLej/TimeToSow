//
//  TimerView.swift
//  TimeToSow
//
//  Created by Nebo on 23.08.2025.
//

import SwiftUI

struct TimerView: View {
    @State private var onSecondsChange: (Int)->()
    @State private var onFinish: (Bool)->()
    
    @State private var calendar = Calendar.current
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var time: String = "-- : --"
    @State private var endDate: Date
    @State private var isActive = true
    
    init(startDate: Date, minutes: Int, onSecondsChange: @escaping (Int)->(), onFinish: @escaping (Bool)->()) {
        self.onFinish = onFinish
        self.onSecondsChange = onSecondsChange
        self.endDate = startDate.getOffsetDate(minutes, component: .minute)
    }
    
    var body: some View {
        Text(time)
            .font(.myNumber(70))
            .foregroundStyle(.black)
            .onAppear {
                calendar.timeZone = TimeZone(secondsFromGMT: 0)!
            }
            .onReceive(timer) { _ in
                updateCountdown()
            }
    }
    
    private func updateCountdown() {
        if !isActive { return }
        
        let now = Date()
        let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
        
        if diff <= 0 {
            onFinish(true)
            isActive = false
            time = "0:00"
            return
        }
        
        let date = Date(timeIntervalSince1970: diff)
        
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        let sec = calendar.component(.second, from: date)
        
        time = String(format: "%d:%02d", (hour * 60) + min, sec)
        onSecondsChange(hour * 3600 + min * 60 + sec)
    }
}


#Preview {
    screenBuilderMock.getScreen(type: .progress(TaskModel(id: UUID(), startTime: Date(), time: 1, tag: Tag(id: UUID(), stableId: "sss", name: "ff", color: "", isDeleted: false), plant: nil)))
}

