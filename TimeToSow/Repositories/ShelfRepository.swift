//
//  ShelfRepository.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

protocol ShelfRepositoryProtocol {
    func getRandomShelf(except: ShelfType?) -> ShelfType
    func getNextShelf(curent: ShelfType, isNext: Bool) -> ShelfType
}

class ShelfRepository: BaseRepository, ShelfRepositoryProtocol {
    
    func getRandomShelf(except: ShelfType?) -> ShelfType {
        let newShelf = shelfs.randomElement()!
        return newShelf != except ? newShelf : getRandomShelf(except: except)
    }
    
    func getNextShelf(curent: ShelfType, isNext: Bool) -> ShelfType {
        guard let index = shelfs.firstIndex(of: curent) else { return shelfs.first! }
        
        print(index)
        if isNext {
            if index + 1 <= shelfs.count - 1 {
                return shelfs[index + 1]
            } else {
                return shelfs[0]
            }
        } else {
            if index - 1 >= 0 {
                return shelfs[index - 1]
            } else {
                return shelfs.last!
            }
        }
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
