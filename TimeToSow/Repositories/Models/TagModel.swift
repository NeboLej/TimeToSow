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
    var name: String = ""
    var color: String = ""
    
    var notes: [NoteModel] = []
    
    init(id: UUID, name: String, color: String ) {
        self.id = id
        self.name = name
        self.color = color
    }
    
    convenience init(from: Tag) {
        self.init(id: from.id, name: from.name, color: from.color)
    }
}
