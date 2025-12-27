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
        
        let plants = [ Plant(seed: tmpSeed,
                             pot: Pot(potType: .small,
                                   name: "aeded",
                                   image: "pot15",
                                   height: 20,
                                      rarity: .common,
                                   anchorPointCoefficient: .init(x: -0.15, y: 0)),
                             name: "test",
                             description: "",
                             offsetY: 200,
                             offsetX: 0,
                             notes: [Note(date: Date(), time: 100, tag: Tag(name: "Name", color: "#3D90D9"))])
          ]
        var plantDict: [String: Plant] = [:]
        plants.forEach {
            plantDict[$0.id] = $0
        }
        
        return UserMonthRoom(shelfType: ShelfType(name: "First",
                                           image: "shelf3",
                                           shelfPositions: [
                                            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5),
                                            ShelfPosition(coefOffsetY: 0.679, paddingLeading: 30, paddingTrailing: 266),
                                            ShelfPosition(coefOffsetY: 0.466, paddingLeading: 190, paddingTrailing: 28),
                                            ShelfPosition(coefOffsetY: 0.458, paddingLeading: 20, paddingTrailing: 260),
                                            ShelfPosition(coefOffsetY: 0.256, paddingLeading: 39, paddingTrailing: 170),
                                            ShelfPosition(coefOffsetY: 0.252, paddingLeading: 280, paddingTrailing: 19),
                                           ]),
                      roomType: .init(name: "May", image: "room8"),
                      name: "May",
                      dateCreate: Date(),
                      plants: plantDict
        )
    }
}
