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
    var images: [UUID: URL?] = [:]
    var isShow: Bool = false
    
    init(challanges: [Challenge], images: [UUID : URL?]) {
        self.challanges = challanges
        self.images = images
        self.isShow = !challanges.isEmpty
    }
}
