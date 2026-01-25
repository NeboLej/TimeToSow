//
//  DecorTypeModelGRDB.swift
//  TimeToSow
//
//  Created by Nebo on 25.01.2026.
//

import Foundation
import GRDB

struct DecorTypeModelGRDB: Codable, FetchableRecord, MutablePersistableRecord, TableRecord {
    static let databaseTableName = "decorType"
    mutating func didInsert(with rowID: Int64, for column: String?) { }

    var id: UUID
    var name: String
    var locationType: LocationType
    var animationOptions: AnimationOptions?
    var resourceName: String
    var height: CGFloat
    var width: CGFloat

    init(from: DecorType) {
        id = from.id
        name = from.name
        locationType = from.locationType
        animationOptions = from.animationOptions
        resourceName = from.resourceName
        height = from.height
        width = from.width
    }
}
