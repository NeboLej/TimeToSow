//
//  RewardChallengeState.swift
//  TimeToSow
//
//  Created by Nebo on 02.02.2026.
//

import Foundation

struct RewardChallengeState: Equatable {
//    let id = UUID()
    let challanges: [Challenge]
    let isShow: Bool
    
    init(challanges: [Challenge]) {
        
        let ff: [Challenge] = [
            Challenge(from: ChallengeModel(id: "asd", title: "new ddd", type: .consciousLogging, expectedValue: 30, expectedSecondValue: nil, reward: tmpDecorModel1)),
            Challenge(from: ChallengeModel(id: "as123d", title: "new fffff", type: .differentTagsUsed, expectedValue: 30, expectedSecondValue: nil, reward: tmpDecorModel2)),
        ]
        
        self.challanges = challanges
        self.isShow = !challanges.isEmpty
    }
}

fileprivate let tmpDecorModel1: DecorModel = DecorModel(name: "addss", locationType: .free, animationOptions: nil, resourceUrl: "fff", height: 40)
fileprivate let tmpDecorModel2: DecorModel = DecorModel(name: "addss", locationType: .free, animationOptions: nil, resourceUrl: "fff", height: 40)
