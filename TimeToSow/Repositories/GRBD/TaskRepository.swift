//
//  TaskRepository.swift
//  TimeToSow
//
//  Created by Nebo on 05.02.2026.
//

import Foundation
import GRDB

protocol TaskRepositoryProtocol {
    func addTask(_ task: TaskModel) async
    func getTask() async -> TaskModel?
    func updateTask(_ task: TaskModel) async
    func deleteTask() async
}

final class TaskRepository: BaseRepository, TaskRepositoryProtocol {
    
    func addTask(_ task: TaskModel) async {
        await deleteTask()
        
        do {
            try await dbPool.write { db in
                var newTask = TaskModelGRDB(from: task)
                try newTask.insert(db)
            }
            Logger.log("Success saving new task", location: .GRDB, event: .success)
        } catch {
            Logger.log("Error saving new task", location: .GRDB, event: .error(error))
        }
    }
    
    func getTask() async -> TaskModel? {
        do {
            let tasks = try await dbPool.read { db in
                try TaskModelGRDB
                    .including(required: TaskModelGRDB.tag)
                    .including(optional: TaskModelGRDB.plant
                        .including(optional: PlantModelGRDB.seed)
                        .including(optional: PlantModelGRDB.pot)
                        .including(all: PlantModelGRDB.notes.including(required: NoteModelGRDB.tag))
                    )
                    .including(optional: TaskModelGRDB.rewardPlant
                        .including(optional: PlantModelGRDB.seed)
                        .including(optional: PlantModelGRDB.pot)
                        .including(all: PlantModelGRDB.notes.including(required: NoteModelGRDB.tag))
                    )
                    .fetchAll(db)
                
            }
            if tasks.count == 0 {
                return nil
            } else if tasks.count == 1, let task = tasks.first {
                Logger.log("Success get task", location: .GRDB, event: .success)
                return TaskModel(from: task)
            } else {
                Logger.log("Error fetching tasks, tasks count > 1", location: .GRDB, event: .error(nil))
                return TaskModel(from: tasks.first!)
            }
        } catch {
            Logger.log("Error fetching task", location: .GRDB, event: .error(error))
            return nil
        }
    }
    
    func updateTask(_ task: TaskModel) async {
        do {
            try await dbPool.write { db in
                let taskToUpdate = TaskModelGRDB(from: task)
                try taskToUpdate.update(db)
            }
            Logger.log("Success saving updated task", location: .GRDB, event: .success)
        } catch {
            Logger.log("Error saving updated task", location: .GRDB, event: .error(error))
        }
    }
    
    func deleteTask() async {
        do {
            try await dbPool.write { db in
                let count = try TaskModelGRDB.deleteAll(db)
                if count > 0 {
                    Logger.log("Success deleted \(count) task(s)", location: .GRDB, event: .success)
                }
            }
        } catch {
            Logger.log("Error deleting task", location: .GRDB, event: .error(error))
        }
    }
}
