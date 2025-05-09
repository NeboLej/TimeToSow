//
//  AppStore.swift
//  TimeToSow
//
//  Created by Nebo on 09.05.2025.
//

import Foundation

@Observable
class AppStore {
    
    @ObservationIgnored
    private let shelfRepository: ShelfRepositoryProtocol
    
    init(shelfRepository: ShelfRepositoryProtocol) {
        self.shelfRepository = shelfRepository
    }
}
