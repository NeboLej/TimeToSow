//
//  Room.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

protocol RoomProtocol {
    var id: UUID { get }
    var name: String { get }
    var image: String { get }
}

struct RoomType: Hashable {
    let id: UUID
    let name: String
    let image: String
    
    init(id: UUID = UUID(), name: String, image: String) {
        self.id = id
        self.name = name
        self.image = image
    }
    
    init(from: RoomProtocol) {
        id = from.id
        name = from.name
        image = from.image 
    }
}

extension RoomType {
    var stableId: String {
        name + "-" + image
    }
}
