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
    
    let tmpShelf = ShelfType(name: "First",
                          image: "shelf3",
                          shelfPositions: [
                            ShelfPosition(coefOffsetY: 0.95, paddingLeading: 5, paddingTrailing: 5),
                            ShelfPosition(coefOffsetY: 0.682, paddingLeading: 30, paddingTrailing: 266),
                            ShelfPosition(coefOffsetY: 0.468, paddingLeading: 190, paddingTrailing: 28),
                            ShelfPosition(coefOffsetY: 0.46, paddingLeading: 20, paddingTrailing: 260),
                            ShelfPosition(coefOffsetY: 0.256, paddingLeading: 39, paddingTrailing: 170),
                            ShelfPosition(coefOffsetY: 0.254, paddingLeading: 280, paddingTrailing: 19),
                           ])
    
    func getCurrentRoom() -> UserMonthRoom {
        
        let plants: [Plant] = [
//            Plant(seed: tmpSeed,
//                             pot: tmpPot,
//                             name: "test",
//                             description: "",
//                             offsetY: 200,
//                             offsetX: 150,
//                             notes: [Note(date: Date(), time: 100, tag: Tag(name: "Name", color: "#3D90D9"))])
          ]
        var plantDict: [String: Plant] = [:]
        plants.forEach {
            plantDict[$0.id] = $0
        }
        
        return UserMonthRoom(shelfType: tmpShelf,
                      roomType: .init(name: "May", image: "room8"),
                      name: "December",
                      dateCreate: Date(),
                      plants: plantDict
        )
    }
}
