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
    
    override init(dbPool: DatabasePool) {
        super.init(dbPool: dbPool)
        
        Task {
            await setDefaultValues()
        }
    }
    
    private func setDefaultValues() async {
        do {
            let count = try await dbPool.read { db in
                try TagModelGRDB.fetchCount(db)
            }
            
            if count == 0 {
                try await dbPool.write { db in
                    for defaultTag in DefaultModels.tags {  
                        var tag = TagModelGRDB(from: defaultTag)
                        try tag.insert(db)
                    }
                }
                print("💿 TagRepository: --- default Tags added")
            }
        } catch {
            print("💿 TagRepository: failed to set default tags — \(error)")
        }
    }
    
    func getAllTags() async throws -> [Tag] {
        try await dbPool.read { db in
            try TagModelGRDB.fetchAll(db).map { Tag(from: $0) }
        }
    }
    
    func getRandomTag() async -> Tag {
        do {
            let models = try await getAllTags()
            guard let randoMmodel = models.randomElement() else {
                throw NSError(domain: "TagRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "No tags available"])
            }
            return randoMmodel
        } catch {
            fatalError()
        }
    }
}
