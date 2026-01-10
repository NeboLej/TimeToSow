//
//  Pot.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation
import UIKit

enum PotFeaturesType: Int, Hashable, Equatable, CaseIterable, Codable {
    //узкий
    case narrow = 0
}

protocol PotProtocol {
    var id: UUID { get }
    var potFeatures: [PotFeaturesType] { get }
    var name: String { get }
    var image: String { get }
    var height: Int { get }
    var rarity: Rarity { get }
    var anchorPointCoefficientX: CGFloat? { get }
    var anchorPointCoefficientY: CGFloat? { get }
    var width: CGFloat { get }
}

struct Pot: Hashable {
    let id: UUID
    let potFeatures: [PotFeaturesType]
    let name: String
    let image: String
    let height: Int
    let rarity: Rarity
    let anchorPointCoefficient: CGPoint?
    let width: CGFloat
    
    init(id: UUID = UUID.init(), potFeatures: [PotFeaturesType] = [], name: String, image: String,
         height: Int, rarity: Rarity, anchorPointCoefficient: CGPoint? = nil) {
        self.id = id
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
    
    init(from: PotProtocol) {
        id = from.id
        potFeatures = from.potFeatures
        name = from.name
        image = from.image
        height = from.height
        rarity = from.rarity
        anchorPointCoefficient = CGPoint(x: from.anchorPointCoefficientX ?? 0, y: from.anchorPointCoefficientY ?? 0)
        width = from.width
    }
}
