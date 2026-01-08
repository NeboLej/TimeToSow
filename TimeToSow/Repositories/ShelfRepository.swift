//
//  ShelfRepository.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

protocol ShelfRepositoryProtocol {
    func getRandomShelf(except: ShelfType?) async -> ShelfType
//    func getNextShelf(curent: ShelfType, isNext: Bool) -> ShelfType
}

class ShelfRepository: BaseRepository, ShelfRepositoryProtocol {
    
    
    override init(database: DatabaseRepositoryProtocol) {
        super.init(database: database)
        setDefaultValues()
    }
    
    private func setDefaultValues() {
        Task {
            if try await database.fetchAll(ShelfModel.self).isEmpty {
                try await database.insert(DefaultModels.shelfs.map { ShelfModel(from: $0) })
                print("💿 ShelfRepository: --- default ShelfModels added")
            }
        }
    }
    
    func getAllShelfs() async throws -> [ShelfType] {
        let shelfModels = try await database.fetchAll(ShelfModel.self)
        return shelfModels.map { ShelfType(from: $0) }
    }
    
    func getRandomShelf(except: ShelfType?) async -> ShelfType {
        do {
            let newShelf = try await getAllShelfs().randomElement()!
            return newShelf != except ? newShelf : await getRandomShelf(except: except)
        } catch {
            fatalError()
        }
    }
}
