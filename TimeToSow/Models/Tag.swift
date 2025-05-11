//
//  Tag.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

struct Tag: Hashable {
    let id: UUID = UUID.init()
    let name: String
    let color: String
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
}
