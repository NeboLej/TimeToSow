//
//  Pot.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation
import UIKit

enum PotFeaturesType: Hashable, Equatable, CaseIterable {
    //узкий
    case narrow
}

struct Pot: Hashable {
    let id: UUID = UUID.init()
    let potFeatures: [PotFeaturesType]
    let name: String
    let image: String
    let height: Int
    let rarity: Rarity
    let anchorPointCoefficient: CGPoint?
    let width: CGFloat
    
    init(potFeatures: [PotFeaturesType] = [], name: String, image: String, height: Int, rarity: Rarity, anchorPointCoefficient: CGPoint? = nil) {
        self.potFeatures = potFeatures
        self.name = name
        self.image = image
        self.height = height
        self.rarity = rarity
        self.anchorPointCoefficient = anchorPointCoefficient
        
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
