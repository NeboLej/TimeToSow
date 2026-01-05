//
//  ProgressScreenLocalStore.swift
//  TimeToSow
//
//  Created by Nebo on 23.08.2025.
//

import Foundation

@Observable
class ProgressScreenLocalStore: TimerListenerProtocol {

    enum State {
        case progress, completed
    }
    
    var state: State = .progress
    var progress: Float = 0.0
    var minutes: Int
    var timerVM: TimerVM!
    var newPlant: Plant? = nil
//    Plant(seed: tmpSeed,
//                                                 pot: tmpPot,
//                                                 name: "test",
//                                                 description: "",
//                                                 offsetY: 200,
//                                                 offsetX: 150,
//                                                 notes: [Note(date: Date(), time: 100, tag: Tag(name: "Name", color: "#3D90D9"))])

    
    init(minutes: Int) {
        self.minutes = minutes
        self.timerVM = TimerVM(minutes: Float(minutes), startSecond: 0, parent: self)
    }
    
    
    func calcProgress(newValue: Float) {
        progress = 1.0 - ((100.0 / (Float(minutes) * 60)) * newValue)/100.0
    }
    
    func createPlant() {
        
    }
    
    //MARK: - TimerListenerProtocol
    func timeRuns(seconds: Float) {
        calcProgress(newValue: seconds)
    }
    
    func timeFinish(on: Bool) {
        state = on ? .completed : .progress
    }
}
