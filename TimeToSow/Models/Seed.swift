//
//  Seed.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import UIKit

struct Seed: Hashable {
    var id: UUID
    var name: String = ""
    var unavailavlePotTypes: [PotFeaturesType] = []
    var image: String = ""
    var height: Int
    let rarity: Rarity
    var rootCoordinateCoef: CGPoint?
    var width: CGFloat
    
    init(id: UUID = UUID.init(), name: String, unavailavlePotTypes: [PotFeaturesType] = [],
         image: String, height: Int, rarity: Rarity, rootCoordinateCoef: CGPoint? = nil) {
        self.id = id
        self.name = name
        self.unavailavlePotTypes = unavailavlePotTypes
        self.image = image
        self.height = height
        self.rarity = rarity
        self.rootCoordinateCoef = rootCoordinateCoef
        
        let image = UIImage(named: image)
        let originalWidth = image?.size.width
        let originalHeight = image?.size.height

        if let originalHeight, let originalWidth {
            width = CGFloat(height) * (originalWidth / originalHeight)
        } else {
            width =  CGFloat(height)
        }
    }
    
    init(from: SeedModel) {
        id = from.id
        name = from.name
        unavailavlePotTypes = from.unavailavlePotTypesRaw.compactMap { PotFeaturesType(rawValue: $0) }
        image = from.image
        height = from.height
        rarity = Rarity(rawValue: from.rarityRaw) ?? .common
        rootCoordinateCoef = CGPoint(x: from.rootCoordinateCoefX ?? 0, y: from.rootCoordinateCoefY ?? 0)
        width = from.width
    }
}
