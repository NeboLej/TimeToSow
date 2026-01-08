//
//  SeedModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import SwiftData

@Model
final class SeedModel {
    @Attribute(.unique) var id: UUID
    var name: String = ""
    var unavailavlePotTypesRaw: [Int] = []
    var image: String = ""
    var height: Int
    var rarityRaw: Int
    
    var rootCoordinateCoefX: CGFloat?
    var rootCoordinateCoefY: CGFloat?
    
    var width: CGFloat
    
    init(id: UUID, name: String, unavailavlePotTypesRaw: [Int], image: String, height: Int, rarityRaw: Int, rootCoordinateCoefX: CGFloat?, rootCoordinateCoefY: CGFloat?, width: CGFloat) {
        self.id = id
        self.name = name
        self.unavailavlePotTypesRaw = unavailavlePotTypesRaw
        self.image = image
        self.height = height
        self.rarityRaw = rarityRaw
        self.rootCoordinateCoefX = rootCoordinateCoefX
        self.rootCoordinateCoefY = rootCoordinateCoefY
        self.width = width
    }
    
    init(from: Seed) {
        id = from.id
        name = from.name
        unavailavlePotTypesRaw = from.unavailavlePotTypes.map { $0.rawValue }
        image = from.image
        height = from.height
        rarityRaw = from.rarity.starCount
        rootCoordinateCoefX = from.rootCoordinateCoef?.x
        rootCoordinateCoefY = from.rootCoordinateCoef?.y
        width = from.width
    }
}
