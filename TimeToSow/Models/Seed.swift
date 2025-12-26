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
    let rarity: Rarity
    var rootCoordinateCoef: CGPoint?
    var width: CGFloat
    
    init(name: String, availavlePotTypes: [PotType], image: String, height: Int, rarity: Rarity, rootCoordinateCoef: CGPoint? = nil) {
        self.name = name
        self.availavlePotTypes = availavlePotTypes
        self.image = image
        self.height = height
        self.rarity = rarity
        self.rootCoordinateCoef = rootCoordinateCoef
        
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
