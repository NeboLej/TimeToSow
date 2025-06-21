//
//  ShelfType.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

struct ShelfType: Hashable {
    let id: String = UUID().uuidString
    let name: String
    let image: String
    let shelfPositions: [ShelfPosition]
}

struct ShelfPosition: Hashable {
    let coefOffsetY: CGFloat
    let paddingLeading: CGFloat
    let paddingTrailing: CGFloat
}
