//
//  TagRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation
import GRDB

protocol TagRepositoryProtocol {
    func getRandomTag() async -> Tag
    func getAllTags() async throws -> [Tag]
}

final class TagRepository: BaseRepository, TagRepositoryProtocol {
    
    override func setDefaultValues() async {
        do {
            let existing = Set(try await dbPool.read {
                try String.fetchAll($0, sql: "SELECT stableId FROM tag")
            })
            
            let toInsert = DefaultModels.tags.filter { !existing.contains($0.stableId) }
            if toInsert.isEmpty { return }
            
            try await dbPool.write { db in
                for item in toInsert {
                    if try TagModelGRDB.filter(key: item.id).fetchCount(db) == 0 {
                        var tag = TagModelGRDB(from: item)
                        try tag.insert(db)
                    } else {
                        Logger.log("save new tag error, not uniqe", location: .GRDB, event: .error(nil))
                    }
                }
            }
            Logger.log("default \(toInsert.count) Tags added", location: .GRDB, event: .success)
        } catch {
            Logger.log("Failed to set default tags", location: .GRDB, event: .error(error))
        }
    }
    
    func getAllTags() async throws -> [Tag] {
        try await dbPool.read { db in
            let tags = try TagModelGRDB.fetchAll(db).map { Tag(from: $0) }
            Logger.log("get \(tags.count) Tags", location: .GRDB, event: .success)
            return tags
        }
    }
    
    func getRandomTag() async -> Tag {
        do {
            let models = try await getAllTags()
            guard let randomModel = models.randomElement() else {
                throw NSError(domain: "TagRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "No tags available"])
            }
            Logger.log("get random tag", location: .GRDB, event: .success)
            return randomModel
        } catch {
            Logger.log("Failed to get random tag", location: .GRDB, event: .error(error))
            await setDefaultValues()
            return await getRandomTag()
        }
    }
}
