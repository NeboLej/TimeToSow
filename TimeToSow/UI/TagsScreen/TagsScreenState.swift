//
//  TagsScreenState.swift
//  TimeToSow
//
//  Created by Nebo on 17.01.2026.
//

import Foundation

struct TagsScreenState {
    enum Mode {
        case list, addNewTag
    }
    
    let mode: Mode
    let tagsList: [Tag]
    let selectedTag: Tag?
    
    init(mode: Mode = .list, tagsList: [Tag], selectedTag: Tag?) {
        self.mode = mode
        self.selectedTag = selectedTag
        self.tagsList = tagsList
    }
}
