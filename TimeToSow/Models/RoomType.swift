//
//  Room.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

struct RoomType: Hashable {
    let id: String = UUID().uuidString
    let name: String
    let image: String
}
