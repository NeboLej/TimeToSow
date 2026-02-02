//
//  ChallengeRepository.swift
//  TimeToSow
//
//  Created by Nebo on 24.01.2026.
//

import Foundation
import GRDB

protocol ChallengeRepositoryProtocol {
    func getCurrentChallengeSeason() async -> ChallengeSeason?
    func addNewChallangeSeason(_ challengeSeason: ChallengeSeasonRemote) async
    func getAllCompletedChallanges(seasonID: String) async -> [CompletedChallenge]
    func saveCompletedChallenge(_ challenge: CompletedChallenge) async
}

class ChallengeRepository: BaseRepository, ChallengeRepositoryProtocol {
    
    func getCurrentChallengeSeason() async -> ChallengeSeason? {
        do {
            let latest = try await dbPool.read { db in
                try ChallengeSeasonModelGRDB
                    .limit(1)
                    .fetchOne(db)
            }
            
            if let latest {
                return ChallengeSeason(from: latest)
            } else {
                return nil
            }
        } catch {
            fatalError()
        }
    }
    
    func getAllCompletedChallanges(seasonID: String) async -> [CompletedChallenge] {
        do {
            let challenges = try await dbPool.write { db in
                 try CompletedChallengeModelGRDB
                    .filter(Column("seasonID") == seasonID)
                    .fetchAll(db)
            }
            return challenges.map { CompletedChallenge(from: $0) }
        } catch {
            Logger.log("getAllCompletedChallanges error", location: .GRDB, event: .error(error))
            return []
        }
    }
    
    func saveCompletedChallenge(_ challenge: CompletedChallenge) async {
        do {
            try await dbPool.write { db in
                var new = CompletedChallengeModelGRDB(from: challenge)
                try new.insert(db)
                Logger.log("save new CompletedChallenges", location: .GRDB, event: .success)
            }
        } catch {
            Logger.log("error save new CompletedChallenge", location: .GRDB, event: .error(error))
        }
    }
    
    func addNewChallangeSeason(_ challengeSeason: ChallengeSeasonRemote) async {
        do {
            try await dbPool.write { db in
                try ChallengeSeasonModelGRDB.deleteAll(db)
                if try ChallengeSeasonModelGRDB.fetchCount(db) == 0 {
                    var newSeason = ChallengeSeasonModelGRDB(from: challengeSeason)
                    try newSeason.insert(db)
                    Logger.log("save new challenge season", location: .GRDB, event: .success)
                } else {
                    Logger.log("save new challenge season error", location: .GRDB, event: .success)
                }
            }
        } catch {
            fatalError()
        }
    }
}
