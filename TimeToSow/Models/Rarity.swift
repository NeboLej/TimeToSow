//
//  Rarity.swift
//  TimeToSow
//
//  Created by Nebo on 26.12.2025.
//

import Foundation

enum Rarity {
    case common
    case uncommon
    case rare
    case epic
    case legendary
    
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
