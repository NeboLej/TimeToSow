//
//  DatabaseManager.swift
//  TimeToSow
//
//  Created by Nebo on 10.01.2026.
//

import Foundation
import GRDB

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    let dbPool: DatabasePool
    
    private init() {
        let databaseURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("plantApp.sqlite")
        
        var config = Configuration()
        config.prepareDatabase { db in
            try db.execute(sql: "PRAGMA foreign_keys = ON")
            
            try Self.createTablesIfNeeded(in: db)
        }
        
        do {
            dbPool = try DatabasePool(path: databaseURL.path, configuration: config)
        } catch {
            fatalError("Ошибка создания DatabasePool: \(error)")
        }
    }
    
    private static func createTablesIfNeeded(in db: Database) throws {
        try db.create(table: "tag", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("name", .text).notNull()
            t.column("color", .text).notNull()
        }
        
        try db.create(table: "shelf", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("name", .text).notNull()
            t.column("image", .text).notNull()
            t.column("shelfPositions", .blob).notNull()
        }
        
        try db.create(table: "room", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("name", .text).notNull()
            t.column("image", .text).notNull()
        }
        
        try db.create(table: "pot", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("potFeatures", .blob).notNull()
            t.column("name", .text).notNull()
            t.column("image", .text).notNull()
            t.column("height", .integer).notNull()
            t.column("rarity", .integer).notNull()
            t.column("anchorPointCoefficientX", .double)
            t.column("anchorPointCoefficientY", .double)
            t.column("width", .double).notNull()
        }
        
        try db.create(table: "seed", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("name", .text).notNull()
            t.column("unavailavlePotTypes", .blob).notNull()
            t.column("image", .text).notNull()
            t.column("height", .integer).notNull()
            t.column("rarity", .integer).notNull()
            t.column("rootCoordinateCoefX", .double)
            t.column("rootCoordinateCoefY", .double)
            t.column("width", .double).notNull()
        }
        
        try db.create(table: "userRoom", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("shelfID", .blob).notNull()
            t.column("roomID", .blob).notNull()
            t.column("name", .text).notNull()
            t.column("dateCreate", .double).notNull()
            
            t.foreignKey(["shelfID"], references: "shelf", onDelete: .restrict, onUpdate: .cascade)
            t.foreignKey(["roomID"], references: "room", onDelete: .restrict, onUpdate: .cascade)
        }
        
        try db.create(table: "plant", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("seedID", .blob).notNull()
            t.column("potID", .blob).notNull()
            t.column("name", .text).notNull()
            t.column("userDescription", .text).notNull()
            t.column("offsetY", .double).notNull()
            t.column("offsetX", .double).notNull()
            t.column("time", .integer).notNull()
            t.column("rootRoomID", .blob).notNull()
            
            t.foreignKey(["seedID"], references: "seed", onDelete: .restrict, onUpdate: .cascade)
            t.foreignKey(["potID"], references: "pot", onDelete: .restrict, onUpdate: .cascade)
            t.foreignKey(["rootRoomID"], references: "userRoom", onDelete: .cascade, onUpdate: .cascade)
        }
        
        try db.create(table: "note", ifNotExists: true) { t in
            t.column("id", .blob).primaryKey()
            t.column("date", .double).notNull()
            t.column("time", .integer).notNull()
            t.column("plantID", .blob).notNull()
            t.column("tagID", .blob).notNull()
            
            t.foreignKey(["plantID"],  references: "plant", onDelete: .cascade, onUpdate: .cascade)
            t.foreignKey(["tagID"], references: "tag", onDelete: .restrict, onUpdate: .cascade)
        }
    }
}
