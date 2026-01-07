//
//  TagModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import SwiftData

@Model
final class TagModel {
    @Attribute(.unique) var id: UUID
    var name: String
    var color: String
    
    init(id: UUID = UUID(), name: String = "", color: String = "") {
        self.id = id
        self.name = name
        self.color = color
    }
}

@Model
final class DummyModel {
    var dummy: String
    
    init(dummy: String = "dummy") {
        self.dummy = dummy
    }
}
