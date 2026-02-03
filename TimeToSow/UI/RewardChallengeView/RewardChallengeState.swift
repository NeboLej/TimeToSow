//
//  RewardChallengeState.swift
//  TimeToSow
//
//  Created by Nebo on 02.02.2026.
//

import Foundation

struct RewardChallengeState: Equatable {
    var id = UUID()
    var challanges: [Challenge]
    var isShow: Bool = false
    
    init(challanges: [Challenge]) {
        self.challanges = challanges
        self.isShow = !challanges.isEmpty
    }
}
