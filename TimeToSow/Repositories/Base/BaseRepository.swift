//
//  BaseRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

class BaseRepository {
    let database: DatabaseRepositoryProtocol
    
    init(database: DatabaseRepositoryProtocol) {
        self.database = database
    }
}

import GRDB

class BaseRepository1 {
    let dbPool: DatabasePool
    
    init(dbPool: DatabasePool) {
        self.dbPool = dbPool
    }
}
