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
    var version: Int
    var title: String
    var startDate: Date
    var endDate: Date
    var challenges: [ChallengeModel]
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from: ChallengeSeasonRemote) {
        self.id = UUID()
        self.version = from.version
        self.title = from.title
        self.startDate = from.startDate
        self.endDate = from.endDate
        self.challenges = from.challenges
    }
}
