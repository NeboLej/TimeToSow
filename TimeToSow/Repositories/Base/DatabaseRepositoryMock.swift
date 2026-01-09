//
//  DatabaseRepositoryMock.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import Foundation
import SwiftData

actor MockDatabaseRepository: DatabaseRepositoryProtocol {

    
    
    private var storage: [String: Any] = [:] // Простое in-memory хранилище по типу
    
    // MARK: Insert
    func insert<T: PersistentModel>(_ model: T) async throws {
        let key = String(describing: T.self)
        var array = storage[key] as? [T] ?? []
        array.append(model)
        storage[key] = array
    }
    
    func insert<T: PersistentModel>(_ models: [T]) async throws {
        for model in models {
            try await insert(model)
        }
    }
    
    // MARK: Fetch
    func fetchAll<T: PersistentModel>(_ type: T.Type) async throws -> [T] {
        let key = String(describing: T.self)
        var array = (storage[key] as? [T]) ?? []
        
//        if let predicate = predicate {
//            array = try array.filter { try predicate.evaluate($0) }
//        }
        
        // Сортировка (простая реализация для распространённых случаев)
//        if !sortBy.isEmpty {
            // Здесь можно реализовать сортировку, если нужно
            // Для превью часто достаточно без сортировки
//        }
        
        return array
    }
    
    func fetchAll<T>(predicate: Predicate<T>?) async throws -> [T] where T : PersistentModel {
        let key = String(describing: T.self)
        var array = (storage[key] as? [T]) ?? []
        
        if let predicate = predicate {
            array = try array.filter { try predicate.evaluate($0) }
        }
        
        return array
    }
    
//
//    func fetchByID<T: PersistentModel>(_ id: PersistentIdentifier) async throws -> T? {
//        return try await fetchAll().first { $0.persistentModelID == id }
//    }
//    
//    func fetchByUUID<T: PersistentModel>(_ uuid: UUID) async throws -> T? where T.ID == UUID {
//        return try await fetchAll().first { $0.id == uuid }
//    }
//    
    // MARK: Update — в моках обычно не нужно, но можно просто игнорировать
    func update<T: PersistentModel>(_ model: T) async throws { }
//    
//    // MARK: Delete
//    func delete<T: PersistentModel>(_ model: T) async throws {
//        let key = String(describing: T.self)
//        if var array = storage[key] as? [T] {
//            array.removeAll { $0.persistentModelID == model.persistentModelID }
//            storage[key] = array
//        }
//    }
    
//    func deleteByID<T: PersistentModel>(_ id: PersistentIdentifier) async throws {
//        if let model = try await fetchByID(id) as? T {
//            try await delete(model)
//        }
//    }
//    
//    func deleteByUUID<T: PersistentModel>(_ uuid: UUID) async throws where T.ID == UUID {
//        if let model = try await fetchByUUID(uuid) as? T {
//            try await delete(model)
//        }
//    }
//    
//    func deleteAll<T: PersistentModel>(predicate: Predicate<T>? = nil) async throws {
//        let key = String(describing: T.self)
//        if let predicate = predicate {
//            var array = (storage[key] as? [T]) ?? []
//            array.removeAll { try predicate.evaluate($0) }
//            storage[key] = array
//        } else {
//            storage[key] = []
//        }
//    }
}
