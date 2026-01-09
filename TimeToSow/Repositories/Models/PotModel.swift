//
//  PotModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import SwiftData

@Model
final class PotModel: PotProtocol {
    @Attribute(.unique) var id: UUID
    var potFeaturesTypeRow: [Int] = []
    var name: String = ""
    var image: String = ""
    var height: Int = 0
    var rarityRaw: Int = 0
    var anchorPointCoefficientX: CGFloat?
    var anchorPointCoefficientY: CGFloat?
    var width: CGFloat = 0
    
    var plants: [PlantModel] = []
    
    var potFeatures: [PotFeaturesType] {
        potFeaturesTypeRow.compactMap { PotFeaturesType(rawValue: $0) }
    }
    
    var rarity: Rarity {
        Rarity(rawValue: rarityRaw) ?? .common
    }
    
    init(id: UUID, potFeaturesTypeRow: [Int], name: String, image: String,
         height: Int, rarityRaw: Int, anchorPointCoefficientX: CGFloat?,
         anchorPointCoefficientY: CGFloat?, width: CGFloat) {
        self.id = id
        self.potFeaturesTypeRow = potFeaturesTypeRow
        self.name = name
        self.image = image
        self.height = height
        self.rarityRaw = rarityRaw
        self.anchorPointCoefficientX = anchorPointCoefficientX
        self.anchorPointCoefficientY = anchorPointCoefficientY
        self.width = width
    }
    
    init(from: Pot) {
        id = from.id
        potFeaturesTypeRow = from.potFeatures.map { $0.rawValue }
        image = from.image
        name = from.name
        height = from.height
        rarityRaw = from.rarity.starCount
        anchorPointCoefficientX = from.anchorPointCoefficient?.x
        anchorPointCoefficientY = from.anchorPointCoefficient?.y
        width = from.width
    }
}


import GRDB

struct PotModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord, PotProtocol {
    static let databaseTableName = "pot"
    
    var id: UUID
    var potFeatures: [PotFeaturesType]
    var name: String
    var image: String
    var height: Int
    var rarity: Rarity
    var anchorPointCoefficientX: CGFloat?
    var anchorPointCoefficientY: CGFloat?
    var width: CGFloat
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
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
