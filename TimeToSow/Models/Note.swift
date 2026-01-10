//
//  Note.swift
//  TimeToSow
//
//  Created by Nebo on 25.12.2025.
//

import Foundation

struct Note: Identifiable, Hashable {
    let id: UUID
    let date: Date
    let time: Int
    let tag: Tag
    
    init(id: UUID = UUID(), date: Date, time: Int, tag: Tag) {
        self.id = id
        self.date = date
        self.time = time
        self.tag = tag
    }
    
    init(from: NoteModelGRDB) {
        id = from.id
        date = from.date
        time = from.time
        tag = Tag(from: from.tag!)
    }
}
