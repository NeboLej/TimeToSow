//
//  PotModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import SwiftData

@Model
final class PotModel {
    var id: UUID
    var potFeatures: [PotFeaturesType]
    var name: String
    var image: String
    var height: Int
    var rarity: Rarity
    var anchorPointCoefficientX: CGFloat?
    var anchorPointCoefficientY: CGFloat?
    var width: CGFloat
    
    init(id: UUID, potFeatures: [PotFeaturesType], name: String, image: String,
         height: Int, rarity: Rarity, anchorPointCoefficientX: CGFloat? = nil,
         anchorPointCoefficientY: CGFloat? = nil, width: CGFloat) {
        self.id = id
        self.potFeatures = potFeatures
        self.name = name
        self.image = image
        self.height = height
        self.rarity = rarity
        self.anchorPointCoefficientX = anchorPointCoefficientX
        self.anchorPointCoefficientY = anchorPointCoefficientY
        self.width = width
    }
    
    init(from: Pot) {
        id = from.id
        potFeatures = from.potFeatures
        image = from.image
        name = from.name
        height = from.height
        rarity = from.rarity
        anchorPointCoefficientX = from.anchorPointCoefficient?.x
        anchorPointCoefficientY = from.anchorPointCoefficient?.y
        width = from.width
    }
}
