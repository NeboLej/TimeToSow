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
}

class ChallengeRepository: BaseRepository, ChallengeRepositoryProtocol {
    
    func getCurrentChallengeSeason() async -> ChallengeSeason? {
        do {
            let latest = try await dbPool.read { db in
                try ChallengeSeasonModelGRDB
//                    .order(Column("dateCreate").desc)
                    .limit(1)
//                    .including(required: UserRoomModelGRDB.shelf)
//                    .including(required: UserRoomModelGRDB.room)
//                    .including(all: UserRoomModelGRDB.plants.including(required: PlantModelGRDB.seed)
//                        .including(required: PlantModelGRDB.seed)
//                        .including(required: PlantModelGRDB.pot)
//                        .including(all: PlantModelGRDB.notes.including(required: NoteModelGRDB.tag)))
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
    
    func addNewChallangeSeason(_ challengeSeason: ChallengeSeasonRemote) async {
        do {
            try await dbPool.write { db in
                try ChallengeSeasonModelGRDB.deleteAll(db)
                if try ChallengeSeasonModelGRDB.fetchCount(db) == 0 {
                    var newSwason = ChallengeSeasonModelGRDB(from: challengeSeason)
                    try newSwason.insert(db)
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
