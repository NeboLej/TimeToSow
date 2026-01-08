//
//  Rarity.swift
//  TimeToSow
//
//  Created by Nebo on 26.12.2025.
//

import Foundation

enum Rarity: Int, Codable {
    case common = 1
    case uncommon = 2
    case rare = 3
    case epic = 4
    case legendary = 5
    
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
