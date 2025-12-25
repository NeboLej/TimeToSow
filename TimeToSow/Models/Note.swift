//
//  Note.swift
//  TimeToSow
//
//  Created by Nebo on 25.12.2025.
//

import Foundation

struct Note: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let date: Date
    let time: Int
    let tag: Tag
}
