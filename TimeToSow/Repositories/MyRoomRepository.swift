//
//  MyRoomRepository.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

protocol MyRoomRepositoryProtocol {
    func getCurrentRoom() -> UserMonthRoom
}

final class MyRoomRepository: BaseRepository, MyRoomRepositoryProtocol {
    
    func getCurrentRoom() -> UserMonthRoom {
        UserMonthRoom(shelfType: ShelfType(name: "First",
                                           image: "shelf1",
                                           shelfPositions: [
                                            ShelfPosition(coefOffsetY: 0.9, paddingLeading: 5, paddingTrailing: 5),
                                            ShelfPosition(coefOffsetY: 0.647, paddingLeading: 31, paddingTrailing: 103),
                                            ShelfPosition(coefOffsetY: 0.48, paddingLeading: 29, paddingTrailing: 28),
                                            ShelfPosition(coefOffsetY: 0.28, paddingLeading: 29, paddingTrailing: 27),
                                           ]),
                      roomType: .init(name: "May", image: "room1"),
                      name: "May",
                      dateCreate: Date(),
                      plants: [
//                        Plant(seed: Seed(name: "asasd",
//                                         availavlePotTypes: [.small, .large, .medium],
//                                         image: "seed1",
//                                         width: 25,
//                                         startTimeInterval: 10,
//                                         endTimeInterval: 100),
//                              pot: Pot(potType: .medium,
//                                       name: "aeded",
//                                       image: "pot1",
//                                       width: 20),
//                              tag: Tag(name: "job",
//                                       color: "555555"),
//                              line: 1),
                        
                        Plant(seed: Seed(name: "asasd2",
                                         availavlePotTypes: [.small, .large, .medium],
                                         image: "seed7",
                                         width: 40,
                                         rootCoordinateCoef: .init(x: 0.2, y: 0.85),
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
