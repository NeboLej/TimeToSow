//
//  Seed.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import UIKit

struct Seed: Hashable {
    var id: UUID = UUID.init()
    var name: String = ""
    var availavlePotTypes: [PotType] = []
    var image: String = ""
    var height: Int
    var rootCoordinateCoef: CGPoint?
    var startTimeInterval: Int
    var endTimeInterval: Int
    var width: CGFloat
    
    init(name: String, availavlePotTypes: [PotType], image: String, height: Int, rootCoordinateCoef: CGPoint? = nil, startTimeInterval: Int, endTimeInterval: Int) {
        self.name = name
        self.availavlePotTypes = availavlePotTypes
        self.image = image
        self.height = height
        self.rootCoordinateCoef = rootCoordinateCoef
        self.startTimeInterval = startTimeInterval
        self.endTimeInterval = endTimeInterval
        
        let image = UIImage(named: image)
        let originalWidth = image?.size.width
        let originalHeight = image?.size.height

        if let originalHeight, let originalWidth {
            width = CGFloat(height) * (originalWidth / originalHeight)
        } else {
            width =  CGFloat(height)
        }
    }
}
