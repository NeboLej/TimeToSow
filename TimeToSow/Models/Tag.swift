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
}

struct Tag: Hashable {
    let id: UUID
    let stableId: String
    let name: String
    let color: String
    
    init(id: UUID = UUID(), stableId: String = "", name: String, color: String) {
        self.id = id
        self.stableId = stableId
        self.name = name
        self.color = color
    }
    
    init(from: TagProtocol) {
        id = from.id
        stableId = from.stableId
        name = from.name
        color = from.color
    }
}
