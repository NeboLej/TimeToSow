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
    
    let tag: Tag
    let plant: Plant?
    
    init(id: UUID, startTime: Date, time: Int, tag: Tag, plant: Plant?) {
        self.id = id
        self.startTime = startTime
        self.time = time
        self.tagID = tag.id
        self.plantID = plant?.id
        self.tag = tag
        self.plant = plant
    }
    
    init(from: TaskModelGRDB) {
        guard let tagModel = from.tag else { fatalError("Tag not fetched") }
        self.id = from.id
        self.startTime = from.startTime
        self.time = from.time
        self.tagID = from.tagID
        self.plantID = from.plantID
        self.tag = Tag(from: tagModel)
        if let plantModel = from.plant {
            self.plant = Plant(from: plantModel)
        } else {
            self.plant = nil
        }
    }
}
