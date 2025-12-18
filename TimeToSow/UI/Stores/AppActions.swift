//
//  AppActions.swift
//  TimeToSow
//
//  Created by Nebo on 18.12.2025.
//

import Foundation

enum AppAction {
    case selectPlant(Plant?)
    case movePlant(plant: Plant, newPosition: CGPoint)
}
