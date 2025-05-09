//
//  Seed.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

class Seed {
    var id: UUID = UUID.init()
    var name: String = ""
    var availavlePotTypes: [PotType] = []
    var image: String = ""
    var width: Int
    var startTimeInterval: Int
    var endTimeInterval: Int
    
    init(name: String, availavlePotTypes: [PotType], image: String, width: Int, startTimeInterval: Int, endTimeInterval: Int) {
        self.name = name
        self.availavlePotTypes = availavlePotTypes
        self.image = image
        self.width = width
        self.startTimeInterval = startTimeInterval
        self.endTimeInterval = endTimeInterval
    }
}
