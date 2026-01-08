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
    var unavailavlePotTypes: [PotFeaturesType] = []
    var image: String = ""
    var height: Int
    var rarity: Rarity
    
    var rootCoordinateCoefX: CGFloat?
    var rootCoordinateCoefY: CGFloat?
    
    var width: CGFloat
    
    init(id: UUID, name: String, unavailavlePotTypes: [PotFeaturesType], image: String, height: Int, rarity: Rarity, rootCoordinateCoefX: CGFloat? = nil, rootCoordinateCoefY: CGFloat? = nil, width: CGFloat) {
        self.id = id
        self.name = name
        self.unavailavlePotTypes = unavailavlePotTypes
        self.image = image
        self.height = height
        self.rarity = rarity
        self.rootCoordinateCoefX = rootCoordinateCoefX
        self.rootCoordinateCoefY = rootCoordinateCoefY
        self.width = width
    }
    
    init(from: Seed) {
        id = from.id
        name = from.name
        unavailavlePotTypes = from.unavailavlePotTypes
        image = from.image
        height = from.height
        rarity = from.rarity
        rootCoordinateCoefX = from.rootCoordinateCoef?.x
        rootCoordinateCoefY = from.rootCoordinateCoef?.y
        width = from.width
    }
}
