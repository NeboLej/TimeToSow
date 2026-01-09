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
}

struct Tag: Hashable {
    let id: UUID
    let name: String
    let color: String
    
    init(id: UUID = UUID(), name: String, color: String) {
        self.id = id
        self.name = name
        self.color = color
    }
    
    init(from: TagProtocol) {
        id = from.id
        name = from.name
        color = from.color
    }
    
    init(from: TagModelGRDB) {
        id = from.id
        name = from.name
        color = from.color
    }
}
