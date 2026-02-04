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
                try TaskModelGRDB.fetchAll(db)
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
