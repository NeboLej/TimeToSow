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
    
    let tmpShelf = ShelfType(name: "3", image: "shelf6", shelfPositions: [
        ShelfPosition(coefOffsetY: 0.208, paddingLeading: 28, paddingTrailing: 35),
        ShelfPosition(coefOffsetY: 0.43, paddingLeading: 212, paddingTrailing: 40),
        ShelfPosition(coefOffsetY: 0.525, paddingLeading: 36, paddingTrailing: 236),
        ShelfPosition(coefOffsetY: 0.606, paddingLeading: 195, paddingTrailing: 5),
        ShelfPosition(coefOffsetY: 0.935, paddingLeading: 5, paddingTrailing: 5),
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
        var plantDict: [UUID: Plant] = [:]
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
