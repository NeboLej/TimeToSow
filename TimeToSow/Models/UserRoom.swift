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
        hasher.combine(decor)
    }
    
    var id: UUID
    var shelfType: ShelfType
    var roomType: RoomType
    var name: String
    var dateCreate: Date
    var plants: [UUID: Plant]
    var decor: [UUID: Decor]
    
    init(id: UUID = UUID.init(), shelfType: ShelfType, roomType: RoomType, name: String, dateCreate: Date, plants: [UUID: Plant], decor: [UUID: Decor]) {
        self.id = id
        self.shelfType = shelfType
        self.roomType = roomType
        self.name = name
        self.dateCreate = dateCreate
        self.plants = plants
        
        var dict = [UUID: Decor]()
        [tmpRewardDecor1, tmpRewardDecor2, tmpRewardDecor3].forEach {
            dict[$0.id] = $0
        }
        self.decor = dict
    }
    
    init(from: UserRoomModelGRDB) {
        guard let shelf = from.shelf, let room = from.room, let plants = from.plants, let decors = from.decors else {
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
        
        let decorArray = decors.map { Decor(from: $0) }
        var dict = [UUID: Decor]()
        decorArray.forEach {
            dict[$0.id] = $0
        }
        decor = dict
    }
    
    func copy(shelfType: ShelfType? = nil, roomType: RoomType? = nil, name: String? = nil, plants: [UUID: Plant]? = nil) -> UserRoom {
        UserRoom(id: self.id, shelfType: shelfType ?? self.shelfType,
                 roomType: roomType ?? self.roomType, name: name ?? self.name,
                 dateCreate: self.dateCreate, plants: plants ?? self.plants, decor: self.decor)
    }
    
    static var empty = UserRoom(shelfType: .init(name: "", image: "shelf1", shelfPositions: []),
                                roomType: .init(name: "", image: "room1"),
                                name: "", dateCreate: Date(), plants: [:], decor: [:])
}


struct SimpleUserRoom: Identifiable, Hashable {
    let id: UUID
    let name: String
    let dateCreate: Date
    
    init(from: UserRoomModelGRDB) {
        id = from.id
        name = from.name
        dateCreate = from.dateCreate
    }
}
