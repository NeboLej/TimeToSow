//
//  TaskService.swift
//  TimeToSow
//
//  Created by Nebo on 05.02.2026.
//

import Foundation

protocol TaskServiceProtocol {
    func getTask() async -> TaskModel?
    func newTask(_ task: TaskModel)
    func taskCompleted(_ task: TaskModel)
}

final class TaskService: TaskServiceProtocol {
    let repository: TaskRepositoryProtocol
    let localNotificationService: LocalNotificationServiceProtocol
    
    init(repository: TaskRepositoryProtocol, localNotificationService: LocalNotificationServiceProtocol) {
        self.repository = repository
        self.localNotificationService = localNotificationService
    }
    
    func getTask() async -> TaskModel? {
        await repository.getTask()
    }
    
    func newTask(_ task: TaskModel) {
        Task {
            await repository.addTask(task)
            let notification = LocalNotification(type: .taskCompleted, minutes: task.time)
            localNotificationService.add(notification)
        }
    }
    
    func taskCompleted(_ task: TaskModel) {
        Task {
            await repository.deleteTask()
            localNotificationService.deleteAll(withType: .taskCompleted)
        }
    }
}
