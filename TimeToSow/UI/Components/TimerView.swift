//
//  TimerView.swift
//  TimeToSow
//
//  Created by Nebo on 23.08.2025.
//
import SwiftUI


import Foundation

protocol TimerListenerProtocol {
    func timeRuns(seconds: Float)
    func timeFinish(on: Bool)
}


struct TimerView: View {
    
    var vm: TimerVM
    
    var body: some View {
        
        Text(vm.time)
            .font(.myNumber(70))
            .foregroundStyle(.black)
            .onReceive(vm.timer) { _ in
                vm.updateCountdown()
            }
    }
}



@Observable
class TimerVM {
    var time: String = "00:00"
    var minutes: Float = 1 {
        didSet {
            self.time = "\(Int(minutes)):00"
        }
    }
    let startSeconds: Int
    
    private var initialTime = 0
    private var endDate = Date()
    private let parent: Any?
    private var calendar = Calendar.current
    private var isActive: Bool = true
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(minutes: Float, startSecond: Int, parent: Any? = nil) {
        self.minutes = minutes
        self.parent = parent
        self.startSeconds = startSecond
        endDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to: endDate)!
        endDate = Calendar.current.date(byAdding: .second, value: -startSecond, to: endDate)!
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    }
    
    func updateCountdown() {
        guard isActive else { return }
        
        let now = Date()
        let diff = endDate.timeIntervalSince1970 - now.timeIntervalSince1970
        
        if diff <= 0 {
            (parent as? TimerListenerProtocol)?.timeFinish(on: true)
            isActive = false
            time = "0:00"
            return
        }
        
        let date = Date(timeIntervalSince1970: diff)
        
        let hour = calendar.component(.hour, from: date)
        let min = calendar.component(.minute, from: date)
        let sec = calendar.component(.second, from: date)
        
        time = String(format: "%d:%02d", (hour * 60) + min, sec)
        (parent as? TimerListenerProtocol)?.timeRuns(seconds: Float(hour * 3600 + min * 60 + sec))
    }
}
