//
//  SeedModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import GRDB

struct SeedModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord, SeedProtocol {
    static let databaseTableName = "seed"
    
    var id: UUID
    var stableId: String
    var name: String
    var unavailavlePotTypes: [PotFeaturesType]
    var image: String
    var height: Int
    var rarity: Rarity
    var rootCoordinateCoefX: CGFloat?
    var rootCoordinateCoefY: CGFloat?
    var width: CGFloat
    
    mutating func didInsert(with rowID: Int64, for column: String?) { }
    
    init(from: Seed) {
        id = from.id
        stableId = from.stableId
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
