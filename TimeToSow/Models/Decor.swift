//
//  Decor.swift
//  TimeToSow
//
//  Created by Nebo on 21.01.2026.
//

import Foundation

enum LocationType {
    case stand, hand, free
}

struct AnimationOptions: Hashable, Codable {
    let duration: Double
    let repeatCount: Float
    let timeRepetition: Double
}

struct Decor: Hashable, Identifiable {
    let id: UUID
    let name: String
    let locationType: LocationType
    let animationOptions: AnimationOptions?
    let resourceName: String
    let positon: CGPoint
    let height: CGFloat
    let width: CGFloat
}
