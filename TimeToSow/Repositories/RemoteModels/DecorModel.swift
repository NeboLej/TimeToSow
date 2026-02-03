//
//  DecorModel.swift
//  TimeToSow
//
//  Created by Nebo on 25.01.2026.
//

import Foundation

struct DecorModel: Codable, Equatable {
    let name: String
    let locationType: LocationType
    let animationOptions: AnimationOptions?
    let resourceUrl: String
    let height: CGFloat
    
    var imageUrl: URL? {
        LocalImageStore.shared.localURL(for: resourceUrl)
    }
}
