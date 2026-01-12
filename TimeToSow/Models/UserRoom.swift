//
//  Shelf.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

@Observable
class UserRoom: Hashable {
    
    static func == (lhs: UserRoom, rhs: UserRoom) -> Bool {
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
    
    init(from: UserRoomModelGRDB) {
        guard let shelf = from.shelf, let room = from.room, let plants = from.plants else {
            fatalError("requered parameter is nil")
        }
        id = from.id
        shelfType = ShelfType(from: shelf)
        roomType = RoomType(from: room)
        name = from.name
        dateCreate = from.dateCreate
        
        let plantsArray = plants.map { Plant(from: $0) }
        var plantsDict: [UUID: Plant] = [:]
        plantsArray.forEach {
            plantsDict[$0.id] = $0
        }
        self.plants = plantsDict
    }
    
    func copy(shelfType: ShelfType? = nil, roomType: RoomType? = nil, name: String? = nil, plants: [UUID: Plant]? = nil) -> UserRoom {
        UserRoom(id: self.id, shelfType: shelfType ?? self.shelfType,
                      roomType: roomType ?? self.roomType, name: name ?? self.name,
                      dateCreate: self.dateCreate, plants: plants ?? self.plants)
    }
    
    static var empty = UserRoom(shelfType: .init(name: "", image: "shelf1", shelfPositions: []),
                                roomType: .init(name: "", image: "room1"),
                                name: "", dateCreate: Date(), plants: [:])
}


struct SimpleUserRoom: Identifiable, Hashable {
    let id: UUID
    let name: String
    
    init(from: UserRoomModelGRDB) {
        id = from.id
        name = from.name
    }
}
