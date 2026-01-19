//
//  Tag.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol TagProtocol {
    var id: UUID { get }
    var name: String { get }
    var color: String { get }
    var stableId: String { get }
    var isDeleted: Bool { get }
}

struct Tag: Hashable, Identifiable {
    let id: UUID
    let stableId: String
    let name: String
    let color: String
    let isDeleted: Bool
    
    init(id: UUID = UUID(), stableId: String = "", name: String, color: String, isDeleted: Bool = false) {
        self.id = id
        self.stableId = stableId
        self.name = name
        self.color = color
        self.isDeleted = isDeleted
    }
    
    init(from: TagProtocol) {
        id = from.id
        stableId = from.stableId
        name = from.name
        color = from.color
        isDeleted = from.isDeleted
    }
    
    func copy(isDeleted: Bool? = nil) -> Tag {
        Tag(id: self.id, stableId: self.stableId, name: self.name, color: self.color, isDeleted: isDeleted ?? self.isDeleted)
    }
}
