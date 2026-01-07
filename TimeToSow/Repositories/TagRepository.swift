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
//        addData()
    }
    
//    func addData() {
//        Task {
//            try await database.insert(TagModel(id: UUID(), name: "asd", color: "#fff333"))
//        }
//    }
    
    func getAllTags() async throws -> [Tag] {
        let tagModels: [TagModel] = try await database.fetchAll(TagModel.self)
        print(tagModels)
        return tagModels.map { Tag(from: $0) }
    }
    
    func getRandomTag() async -> Tag {
        do {
//            try await database.insert(TagModel(id: UUID(), name: "asd", color: "#fff333"))
            return try await getAllTags().randomElement()!
        } catch {
            fatalError()
        }
    }
//    
//    func getRandomTag() -> Tag {
//        tags.randomElement()!
//    }
    
    private var tags: [Tag] = [
        Tag(name: "Job", color: "#EE05F2"),
        Tag(name: "Yoga", color: "#68F205"),
        Tag(name: "Programm", color: "#F2E205"),
        Tag(name: "Read", color: "#F25C05"),
        Tag(name: "Run in the morning", color: "#8C8303")
    ]
}
