//
//  TagsScreenAction.swift
//  TimeToSow
//
//  Created by Nebo on 17.01.2026.
//

import Foundation

enum TagsScreenAction {
    case changeMode(TagsScreenState.Mode)
    case selectTag(Tag)
    case addNewTag(name: String, color: String)
    case deleteTag(Tag)
}
