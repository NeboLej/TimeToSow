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
    
    var currentShelf: Shelf
    
    init(shelfRepository: ShelfRepositoryProtocol) {
        self.shelfRepository = shelfRepository
        currentShelf = shelfRepository.getCurrentShelf()
    }
    
    func updateShelf() {
        currentShelf = shelfRepository.getCurrentShelf()
    }
}
