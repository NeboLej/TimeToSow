//
//  DatabaseRepository.swift
//  TimeToSow
//
//  Created by Nebo on 08.01.2026.
//

import SwiftData
import Foundation

// MARK: - Protocol для унификации (опционально, но удобно)
protocol PersistentModelProtocol: PersistentModel & Identifiable { }

// Все ваши @Model-классы автоматически соответствуют этому протоколу.

protocol DatabaseRepositoryProtocol {
    // MARK: Insert
    func insert<T: PersistentModel>(_ model: T) async throws
//    func insert<T: PersistentModel>(_ models: [T]) async throws
    
    // MARK: Fetch
    func fetchAll<T: PersistentModel>(_ type: T.Type) async throws -> [T]
    
//    func fetchByID<T: PersistentModel>(_ id: PersistentIdentifier) async throws -> T?
//    func fetchByUUID<T: PersistentModel>(_ uuid: UUID) async throws -> T? where T.ID == UUID
    
    // MARK: Update
//    func update<T: PersistentModel>(_ model: T) async throws
    
    // MARK: Delete
//    func delete<T: PersistentModel>(_ model: T) async throws
//    func deleteByUUID(_ uuid: UUID) async throws
//    func deleteAll<T: PersistentModel>(predicate: Predicate<T>?) async throws
}

@ModelActor
actor DatabaseRepository: DatabaseRepositoryProtocol {
    
//    private let context: ModelContext
    
//    init(context: ModelContext) {
//        self.context = context
//    }
    
    // MARK: Insert
    func insert<T: PersistentModel>(_ model: T) async throws {
        modelContext.insert(model)
        try modelContext.save()
    }
    
//    func insert<T: PersistentModel>(_ models: [T]) async throws {
//        for model in models {
//            context.insert(model)
//        }
//        try context.save()
//    }
    
    // MARK: Fetch
    func fetchAll<T: PersistentModel>(_ type: T.Type) async throws -> [T] {
        let descriptor = FetchDescriptor<T>()
        return try modelContext.fetch(descriptor)
    }
    
//    func fetchByID<T: PersistentModel>(_ id: PersistentIdentifier) async throws -> T? {
//        let descriptor = FetchDescriptor<T>(predicate: #Predicate { $0.persistentModelID == id })
//        return try context.fetch(descriptor).first
//    }
//    
//    func fetchByUUID<T: PersistentModel>(_ uuid: UUID) async throws -> T? where T.ID == UUID {
//        let descriptor = FetchDescriptor<T>(predicate: #Predicate { $0.id == uuid })
//        return try context.fetch(descriptor).first
//    }
    
    // MARK: Update
//    func update<T: PersistentModel>(_ model: T) async throws {
//        try context.save() // SwiftData отслеживает изменения автоматически
//    }
    
    // MARK: Delete
//    func delete<T: PersistentModel>(_ model: T) async throws {
//        context.delete(model)
//        try context.save()
//    }
//    
//    func deleteAll<T: PersistentModel>(predicate: Predicate<T>? = nil) async throws {
//        let descriptor = FetchDescriptor<T>(predicate: predicate)
//        let objects = try context.fetch(descriptor)
//        for object in objects {
//            context.delete(object)
//        }
//        try context.save()
//    }
}
