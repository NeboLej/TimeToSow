//
//  ChallengeModel.swift
//  TimeToSow
//
//  Created by Nebo on 25.01.2026.
//

import Foundation

struct ChallengeModel: Codable {
    let title: String
    let type: ChallengeType
    let expectedValue: Int
    let expectedSecondValue: Int?
    let reward: DecorModel
}
