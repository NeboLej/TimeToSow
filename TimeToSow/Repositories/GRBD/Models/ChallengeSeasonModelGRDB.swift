//
//  ChallengeSeasonModelGRDB.swift
//  TimeToSow
//
//  Created by Nebo on 25.01.2026.
//

import Foundation
import GRDB

struct ChallengeSeasonModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord {
    static let databaseTableName = "challangeSeason"
    var id: UUID
    var stableId: String
    var version: Int
    var title: String
    var startDate: Date
    var endDate: Date
    var challenges: [ChallengeModel]
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from: ChallengeSeasonRemote) {
        self.id = UUID()
        self.stableId = from.id
        self.version = from.version
        self.title = from.title
        self.startDate = from.startDate
        self.endDate = from.endDate
        self.challenges = from.challenges
    }
}

struct CompletedChallengeModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord {
    static let databaseTableName = "completedChallenge"
    
    var id: UUID
    var seasonID: String
    var date: Date
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from: CompletedChallenge) {
        self.id = from.id
        self.seasonID = from.seasonID
        self.date = from.date
    }
}
