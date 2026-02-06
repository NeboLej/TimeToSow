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
    
    let upgradedPlant: Plant?
}
