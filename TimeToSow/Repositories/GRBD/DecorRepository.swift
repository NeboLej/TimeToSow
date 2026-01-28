//
//  DecorRepository.swift
//  TimeToSow
//
//  Created by Nebo on 28.01.2026.
//

import Foundation
import GRDB

protocol DecorRepositoryProtocol {
    func getAllDecorTypes() async -> [DecorType]
    func saveNewDecor(_ decor: Decor) async
    func updateDecor(_ decor: Decor) async
    func saveNewDecorTypes(_ decorTypes: [DecorType]) async
}

final class DecorRepository: BaseRepository, DecorRepositoryProtocol {
    
    func getAllDecorTypes() async -> [DecorType] {
        do {
            return try await dbPool.read { db in
                try DecorTypeModelGRDB
                    .fetchAll(db)
                    .map { DecorType(from: $0) }
            }
        } catch {
            fatalError()
        }
    }
    
    func saveNewDecorTypes(_ decorTypes: [DecorType]) async {
        do {
            let existing = Set(try await dbPool.read {
                try String.fetchAll($0, sql: "SELECT stableId FROM decorType")
            })

            let toInsert = decorTypes.filter { !existing.contains($0.stableId) }
            if toInsert.isEmpty { return }

            try await dbPool.write { db in
                for item in toInsert {
                    if try DecorTypeModelGRDB.filter(key: item.id).fetchCount(db) == 0 {
                        var decorType = DecorTypeModelGRDB(from: item)
                        try decorType.insert(db)
                    } else {
                        Logger.log("save new decorType error, not uniqe", location: .GRDB, event: .error(nil))
                    }
                }
            }

            Logger.log("default \(toInsert.count) decorType added", location: .GRDB, event: .success)
        } catch {
            Logger.log("Failed to set new decor types", location: .GRDB, event: .error(error))
        }
    }
    
    func updateDecor(_ decor: Decor) async {
        do {
            try await dbPool.write { db in
                if try DecorModelGRDB.filter(key: decor.id).fetchCount(db) != 0 {
                    let mutable = DecorModelGRDB(from: decor)
                    try mutable.update(db)
                    Logger.log("update decor", location: .GRDB, event: .success)
                } else {
                    Logger.log("update decor error. decor not found", location: .GRDB, event: .error(nil))
                }
            }
        } catch {
            Logger.log("update decor error", location: .GRDB, event: .error(error))
        }
    }
    
    func saveNewDecor(_ decor: Decor) async {
        do {
            try await dbPool.write { db in
                if try DecorModelGRDB.filter(key: decor.id).fetchCount(db) == 0 {
                    var mutable = DecorModelGRDB(from: decor)
                    try mutable.insert(db)
                    Logger.log("save new decor", location: .GRDB, event: .success)
                } else {
                    Logger.log("save new decor error, decor not uniqe", location: .GRDB, event: .error(nil))
                }
            }
        } catch {
            Logger.log("save new decor error", location: .GRDB, event: .error(error))
        }
    }
}
