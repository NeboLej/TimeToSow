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
        ShelfType(name: "1", image: "shelf1", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5),
            ShelfPosition(coefOffsetY: 0.647, paddingLeading: 31, paddingTrailing: 103),
            ShelfPosition(coefOffsetY: 0.48, paddingLeading: 29, paddingTrailing: 28),
            ShelfPosition(coefOffsetY: 0.28, paddingLeading: 29, paddingTrailing: 27),
        ]),
        
        ShelfType(name: "2", image: "shelf2", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5),
            ShelfPosition(coefOffsetY: 0.647, paddingLeading: 31, paddingTrailing: 103),
            ShelfPosition(coefOffsetY: 0.48, paddingLeading: 29, paddingTrailing: 28),
            ShelfPosition(coefOffsetY: 0.28, paddingLeading: 29, paddingTrailing: 27),
        ]),
        
        ShelfType(name: "3", image: "shelf3", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5),
            ShelfPosition(coefOffsetY: 0.682, paddingLeading: 30, paddingTrailing: 266),
            ShelfPosition(coefOffsetY: 0.468, paddingLeading: 190, paddingTrailing: 28),
            ShelfPosition(coefOffsetY: 0.46, paddingLeading: 20, paddingTrailing: 260),
            ShelfPosition(coefOffsetY: 0.256, paddingLeading: 39, paddingTrailing: 170),
            ShelfPosition(coefOffsetY: 0.254, paddingLeading: 280, paddingTrailing: 19),
           ]),
        
        ShelfType(name: "3", image: "shelf4", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.253, paddingLeading: 19, paddingTrailing: 228),
            ShelfPosition(coefOffsetY: 0.389, paddingLeading: 232, paddingTrailing: 15),
            ShelfPosition(coefOffsetY: 0.538, paddingLeading: 19, paddingTrailing: 206),
            ShelfPosition(coefOffsetY: 0.656, paddingLeading: 236, paddingTrailing: 10),
            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5)
           ]),
        
        ShelfType(name: "3", image: "shelf5", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.137, paddingLeading: 215, paddingTrailing: 115),
            ShelfPosition(coefOffsetY: 0.263, paddingLeading: 140, paddingTrailing: 23),
            ShelfPosition(coefOffsetY: 0.402, paddingLeading: 85, paddingTrailing: 23),
            ShelfPosition(coefOffsetY: 0.407, paddingLeading: 13, paddingTrailing: 333),
            ShelfPosition(coefOffsetY: 0.559, paddingLeading: 85, paddingTrailing: 115),
            ShelfPosition(coefOffsetY: 0.681, paddingLeading: 308, paddingTrailing: 23),
            ShelfPosition(coefOffsetY: 0.693, paddingLeading: 13, paddingTrailing: 333),
            ShelfPosition(coefOffsetY: 0.827, paddingLeading: 308, paddingTrailing: 23),
            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5)
           ]),
        
        ShelfType(name: "3", image: "shelf6", shelfPositions: [
            ShelfPosition(coefOffsetY: 0.208, paddingLeading: 28, paddingTrailing: 35),
            ShelfPosition(coefOffsetY: 0.43, paddingLeading: 212, paddingTrailing: 40),
            ShelfPosition(coefOffsetY: 0.525, paddingLeading: 36, paddingTrailing: 236),
            ShelfPosition(coefOffsetY: 0.606, paddingLeading: 195, paddingTrailing: 5),
            ShelfPosition(coefOffsetY: 0.935, paddingLeading: 5, paddingTrailing: 5),
           ])
    ]
}
