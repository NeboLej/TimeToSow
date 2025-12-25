//
//  TagRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol TagRepositoryProtocol {
    func getRandomTag() -> Tag
}

final class TagRepository: BaseRepository, TagRepositoryProtocol {
    
    func getRandomTag() -> Tag {
        tags.randomElement()!
    }
    
    private var tags: [Tag] = [
        Tag(name: "Job", color: "#EE05F2"),
        Tag(name: "Yoga", color: "#68F205"),
        Tag(name: "Programm", color: "#F2E205"),
        Tag(name: "Read", color: "#F25C05"),
        Tag(name: "Run in the morning", color: "#8C8303")
    ]
}
