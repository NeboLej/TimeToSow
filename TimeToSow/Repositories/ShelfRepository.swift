//
//  ShelfRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol ShelfRepositoryProtocol {
    func getCurrentShelf() -> Shelf
}

final class ShelfRepository: BaseRepository, ShelfRepositoryProtocol {
    
    func getCurrentShelf() -> Shelf {
        Shelf(type: ShelfType(name: "First",
                              image: "shelf1",
                              shelfPositions: [
                                ShelfPosition(coefOffsetY: 0.9, paddingLeading: 5, paddingTrailing: 5),
                                ShelfPosition(coefOffsetY: 0.647, paddingLeading: 31, paddingTrailing: 103),
                                ShelfPosition(coefOffsetY: 0.48, paddingLeading: 29, paddingTrailing: 28),
                                ShelfPosition(coefOffsetY: 0.28, paddingLeading: 29, paddingTrailing: 27),
                              ]),
              name: "May",
              dateCreate: Date(),
              plants: [
                Plant(seed: Seed(name: "asasd",
                                 availavlePotTypes: [.small, .large, .medium],
                                 image: "seed1",
                                 width: 25,
                                 startTimeInterval: 10,
                                 endTimeInterval: 100),
                      pot: Pot(potType: .medium,
                               name: "aeded",
                               image: "pot1",
                               width: 20),
                      tag: Tag(name: "job",
                               color: "555555"),
                      line: 2),
                
                Plant(seed: Seed(name: "asasd",
                                 availavlePotTypes: [.small, .large, .medium],
                                 image: "seed1",
                                 width: 40,
                                 startTimeInterval: 10,
                                 endTimeInterval: 100),
                      pot: Pot(potType: .medium,
                               name: "aeded",
                               image: "pot1",
                               width: 30),
                      tag: Tag(name: "job",
                               color: "555555"),
                      line: 0)
              ])
    }
}
