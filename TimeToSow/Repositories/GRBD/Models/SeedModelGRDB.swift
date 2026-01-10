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
