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
    func saveRewardForTheTask(_ task: TaskModel, reward plant: Plant)
    func stopTask()
}

final class TaskService: TaskServiceProtocol {
    let repository: TaskRepositoryProtocol
    let plantRepository: PlantRepositoryProtocol
    let localNotificationService: LocalNotificationServiceProtocol
    
    init(repository: TaskRepositoryProtocol,
         plantRepository: PlantRepositoryProtocol,
         localNotificationService: LocalNotificationServiceProtocol) {
        self.repository = repository
        self.plantRepository = plantRepository
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
    
    func stopTask() {
        Task {
            localNotificationService.deleteAll(withType: .taskCompleted)
            await repository.deleteTask()
        }
    }
    
    func taskCompleted(_ task: TaskModel) {
        Task {
            await repository.deleteTask()
        }
    }
    
    func saveRewardForTheTask(_ task: TaskModel, reward plant: Plant) {
        Task {
            localNotificationService.deleteAll(withType: .taskCompleted)
            await plantRepository.saveNewPlant(plant)
            let newTask = task.copy(rewardPlant: plant)
            await repository.updateTask(newTask)
        }
    }
}
