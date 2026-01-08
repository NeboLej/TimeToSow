//
//  TagRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol TagRepositoryProtocol {
    func getRandomTag() async -> Tag
}

final class TagRepository: BaseRepository, TagRepositoryProtocol {
    
    override init(database: DatabaseRepositoryProtocol) {
        super.init(database: database)
        setDefaultValues()
    }
    
    private func setDefaultValues() {
        Task {
            if try await database.fetchAll(TagModel.self).isEmpty {
                try await database.insert(DefaultModels.tags.map { TagModel(from: $0) })
                print("💿 TagRepository: --- default TagModel added")
            }
        }
    }
    
    func getAllTags() async throws -> [Tag] {
        let tagModels: [TagModel] = try await database.fetchAll(TagModel.self)
        return tagModels.map { Tag(from: $0) }
    }
    
    func getRandomTag() async -> Tag {
        do {
            return try await getAllTags().randomElement()!
        } catch {
            fatalError()
        }
    }
}
