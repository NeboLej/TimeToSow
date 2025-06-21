//
//  ShelfRepository.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

protocol ShelfRepositoryProtocol {
    func getRandomShelf(except: ShelfType?) -> ShelfType
}

class ShelfRepository: BaseRepository, ShelfRepositoryProtocol {
    
    func getRandomShelf(except: ShelfType?) -> ShelfType {
        let newShelf = shelfs.randomElement()!
        return newShelf != except ? newShelf : getRandomShelf(except: except)
    }
    
    
    private var shelfs: [ShelfType] = [
        ShelfType(name: "First",
                  image: "shelf1",
                  shelfPositions: [
                    ShelfPosition(coefOffsetY: 0.9, paddingLeading: 5, paddingTrailing: 5),
                    ShelfPosition(coefOffsetY: 0.647, paddingLeading: 31, paddingTrailing: 103),
                    ShelfPosition(coefOffsetY: 0.48, paddingLeading: 29, paddingTrailing: 28),
                    ShelfPosition(coefOffsetY: 0.28, paddingLeading: 29, paddingTrailing: 27),
                  ]),
        
        ShelfType(name: "Second", image: "shelf2", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.9, paddingLeading: 5, paddingTrailing: 5),
            ShelfPosition(coefOffsetY: 0.647, paddingLeading: 31, paddingTrailing: 103),
//            ShelfPosition(coefOffsetY: 0.48, paddingLeading: 10, paddingTrailing: 100),
            ShelfPosition(coefOffsetY: 0.28, paddingLeading: 29, paddingTrailing: 27),
          ])
    ]
}
