//
//  Shelf.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

class ShelfType {
    var name: String = ""
}

class Shelf {
    var id: UUID = UUID.init()
    var type: ShelfType = ShelfType()
    var name: String = ""
    var dateCreate: Date = Date()
    var plants: [Plant] = []
}
