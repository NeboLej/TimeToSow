//
//  Tag.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

struct Tag: Hashable {
    let id: UUID
    let name: String
    let color: String
    
    init(id: UUID = UUID.init(), name: String, color: String) {
        self.id = id
        self.name = name
        self.color = color
    }
    
    init(from: TagModel) {
        id = from.id
        name = from.name
        color = from.color
    }
}
