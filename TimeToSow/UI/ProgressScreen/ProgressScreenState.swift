//
//  ProgressScreenState.swift
//  TimeToSow
//
//  Created by Nebo on 05.02.2026.
//

import Foundation

struct ProgressScreenState {
    enum State: Equatable {
        case progress, completed(Plant)
    }
    
    let state: State
    let minutes: Int
    let startDate: Date
}

//enum ProgressScreenStateType: Hashable {
//    case new(TaskModel)
//    case progress(TaskModel)
//    
//    var minutes: Int {
//        switch self {
//        case .new(let task), .progress(let task): task.time
//        }
//    }
//    
//    var startDate: Date {
//        switch self {
//        case .new(let task), .progress(let task): task.startTime
//        }
//    }
//    
//    var tag: Tag {
//        switch self {
//        case .new(let task), .progress(let task): task.tag
//        }
//    }
//}
