//
//  ChallengeSeasonRemote.swift
//  TimeToSow
//
//  Created by Nebo on 25.01.2026.
//

import Foundation

struct ChallengeSeasonRemote: Codable {
    let id: String
    let version: Int
    let title: String
    let startDate: Date
    let endDate: Date
    let challenges: [ChallengeModel]
}
