//
//  Tag.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

class Tag {
    var id: UUID = UUID.init()
    var name: String
    var color: String
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
}
