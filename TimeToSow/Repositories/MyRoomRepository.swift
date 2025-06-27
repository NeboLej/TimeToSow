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
                                           image: "shelf3",
                                           shelfPositions: [
                                            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5),
                                            ShelfPosition(coefOffsetY: 0.679, paddingLeading: 30, paddingTrailing: 266),
                                            ShelfPosition(coefOffsetY: 0.466, paddingLeading: 190, paddingTrailing: 28),
                                            ShelfPosition(coefOffsetY: 0.458, paddingLeading: 20, paddingTrailing: 260),
                                            ShelfPosition(coefOffsetY: 0.256, paddingLeading: 39, paddingTrailing: 170),
                                            ShelfPosition(coefOffsetY: 0.252, paddingLeading: 280, paddingTrailing: 19),
                                           ]),
                      roomType: .init(name: "May", image: "room9"),
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
                        
                        Plant(seed:         Seed(name: "asasd2",
                                                 availavlePotTypes: [.large],
                                                 image: "seed15",
                                                 height: 35,
                                                 startTimeInterval: 10,
                                                 endTimeInterval: 100),
                              
                              pot:         Pot(potType: .small,
                                               name: "aeded",
                                               image: "pot13",
                                               height: 16,
                                               anchorPointCoefficient: .init(x: -0.15, y: 0)),
                              tag: Tag(name: "job",
                                       color: "555555"),
                              line: 0)
                      ])
    }
}
