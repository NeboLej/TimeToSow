//
//  SeedModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import SwiftData

@Model
final class SeedModel: SeedProtocol {
    @Attribute(.unique) var id: UUID
    var name: String = ""
    var unavailavlePotTypesRaw: [Int] = []
    var image: String = ""
    var height: Int = 0
    var rarityRaw: Int = 0
    
    var plants: [PlantModel] = []
    
    var rootCoordinateCoefX: CGFloat?
    var rootCoordinateCoefY: CGFloat?
    
    var width: CGFloat = 0
    
    var unavailavlePotTypes: [PotFeaturesType] {
        unavailavlePotTypesRaw.compactMap { PotFeaturesType(rawValue: $0) }
    }
    
    var rarity: Rarity {
        Rarity(rawValue: rarityRaw) ?? .common
    }
    
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

import GRDB

struct SeedModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord, SeedProtocol {
    static let databaseTableName = "seed"
    
    var id: UUID
    var name: String
    var unavailavlePotTypes: [PotFeaturesType]
    var image: String
    var height: Int
    var rarity: Rarity
    var rootCoordinateCoefX: CGFloat?
    var rootCoordinateCoefY: CGFloat?
    var width: CGFloat
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from1: Seed) {
        id = from1.id
        name = from1.name
        unavailavlePotTypes = from1.unavailavlePotTypes
        image = from1.image
        height = from1.height
        rarity = from1.rarity
        rootCoordinateCoefX = from1.rootCoordinateCoef?.x
        rootCoordinateCoefY = from1.rootCoordinateCoef?.y
        width = from1.width
    }
}
