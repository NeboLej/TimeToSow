//
//  TaskModel.swift
//  TimeToSow
//
//  Created by Nebo on 05.02.2026.
//

import Foundation

struct TaskModel: Hashable {
    let id: UUID
    let startTime: Date
    let time: Int
    let tagID: UUID
    let plantID: UUID?
    let rewardPlantID: UUID?
    
    let tag: Tag
    let plant: Plant?
    let rewardPlant: Plant?
    
    init(id: UUID, startTime: Date, time: Int, tag: Tag, plant: Plant?, rewardPlant: Plant? = nil) {
        self.id = id
        self.startTime = startTime
        self.time = time
        
        self.tagID = tag.id
        self.plantID = plant?.id
        self.rewardPlantID = rewardPlant?.id
        
        self.tag = tag
        self.plant = plant
        self.rewardPlant = rewardPlant
    }
    
    init(from: TaskModelGRDB) {
        guard let tagModel = from.tag else { fatalError("Tag not fetched") }
        self.id = from.id
        self.startTime = from.startTime
        self.time = from.time
        self.tagID = from.tagID
        self.plantID = from.plantID
        self.tag = Tag(from: tagModel)
        self.rewardPlantID = from.rewardPlantID
        
        if let reward = from.rewardPlant {
            self.rewardPlant = Plant(from: reward)
        } else {
            self.rewardPlant = nil
        }
        if let plantModel = from.plant {
            self.plant = Plant(from: plantModel)
        } else {
            self.plant = nil
        }
    }
    
    func copy(rewardPlant: Plant? = nil) -> TaskModel {
        TaskModel(id: self.id, startTime: self.startTime,
                  time: self.time, tag: self.tag, plant: self.plant,
                  rewardPlant: rewardPlant ?? self.rewardPlant)
    }
}
