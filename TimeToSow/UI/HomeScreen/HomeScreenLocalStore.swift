//
//  HomeScreenLocalStore.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import SwiftUI

@Observable
class HomeScreenLocalStore {
    
    var currenRoom: UserMonthRoom = .empty
    
    func setCurrentRoom(room: UserMonthRoom) {
        currenRoom = room
    }
}
