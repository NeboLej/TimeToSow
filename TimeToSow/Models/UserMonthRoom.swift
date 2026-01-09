//
//  Shelf.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

@Observable
class UserMonthRoom: Hashable {
    
    static func == (lhs: UserMonthRoom, rhs: UserMonthRoom) -> Bool {
        lhs.id == rhs.id &&
        lhs.plants == rhs.plants &&
        lhs.shelfType == rhs.shelfType &&
        lhs.roomType == rhs.roomType
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(shelfType)
        hasher.combine(plants)
        hasher.combine(roomType)
    }
    
    var id: UUID
    var shelfType: ShelfType
    var roomType: RoomType
    var name: String
    var dateCreate: Date
    var plants: [UUID: Plant]
    
    init(id: UUID = UUID.init(), shelfType: ShelfType, roomType: RoomType, name: String, dateCreate: Date, plants: [UUID: Plant]) {
        self.id = id
        self.shelfType = shelfType
        self.roomType = roomType
        self.name = name
        self.dateCreate = dateCreate
        self.plants = plants
    }
    
    init(from: MonthRoomModel) {
        id = from.id
        shelfType = ShelfType(from: from.shelfType!)
        roomType = RoomType(from: from.roomType!)
        name = from.name
        dateCreate = from.dateCreate
        let plantsArray = from.plants.map { Plant(from: $0) }
        var plantsDict: [UUID: Plant] = [:]
        plantsArray.forEach {
            plantsDict[$0.id] = $0
        }
        plants = plantsDict
    }
    
    func copy(shelfType: ShelfType? = nil, roomType: RoomType? = nil, name: String? = nil, plants: [UUID: Plant]? = nil) -> UserMonthRoom {
        UserMonthRoom(id: self.id, shelfType: shelfType ?? self.shelfType,
                      roomType: roomType ?? self.roomType, name: name ?? self.name,
                      dateCreate: self.dateCreate, plants: plants ?? self.plants)
    }
    
    static var empty = UserMonthRoom(shelfType: .init(name: "", image: "", shelfPositions: []), roomType: .init(name: "", image: ""), name: "", dateCreate: Date(), plants: [:])
}
