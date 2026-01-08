//
//  Rarity.swift
//  TimeToSow
//
//  Created by Nebo on 26.12.2025.
//

import Foundation

enum Rarity: String, Codable {
    case common
    case uncommon
    case rare
    case epic
    case legendary
    
    static let SCALE_DIVISION_VALUE: Int = 30
    
    var starCount: Int {
        switch self {
        case .common: 1
        case .uncommon: 2
        case .rare: 3
        case .epic: 4
        case .legendary: 5
        }
    }
}
