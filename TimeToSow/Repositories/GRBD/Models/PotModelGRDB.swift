//
//  PotModel.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
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
