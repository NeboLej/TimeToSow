//
//  BoxScreenStore.swift
//  TimeToSow
//
//  Created by Nebo on 28.01.2026.
//

import SwiftUI

@Observable
final class BoxScreenStore: FeatureStore {
    
    var state: BoxScreenState = BoxScreenState(plants: [], decors: [])
    
    private var boxPlants: [Plant] = []
    private var boxDecor: [Decor] = []
    
    override init(appStore: AppStore) {
        super.init(appStore: appStore)
        
        let plants = appStore.currentRoom.plants
        
        boxPlants = plants.filter { !$0.value.isOnShelf }.map { $0.value }.sorted(by: { $1.dateCreate > $0.dateCreate })
        boxDecor = appStore.currentRoom.decor.map { $0.value }
        
        rebuildState()
    }
    
    func send(_ action: BoxScreenAction, animation: Animation? = .default) {
        if let animation {
            withAnimation(animation) {
                handle(action)
                appStoreSend(action)
            }
        } else {
            handle(action)
            appStoreSend(action)
        }
    }
    
    
    //MARK: - Private
    private func handle(_ action: BoxScreenAction) {
        switch action {
        case .toShelfPlant(let plant):
            boxPlants.removeAll(where: { plant == $0 })
            rebuildState()
        case .toShelfDecor(let decor):
            boxDecor.removeAll(where: { decor == $0 })
            rebuildState()
        default: break
        }
    }
    
    private func appStoreSend(_ action: BoxScreenAction) {
        switch action {
        case .toShelfPlant(let plant):
            appStore.send(.changeShelfVisibility(plant: plant, isVisible: true))
        case .toShelfDecor(let decor): break
        case .infoPlant(let plant):
            appStore.send(AppAction.detailPlant(plant))
        case .infoDecor(let decor): break
        }
    }
    
    private func rebuildState() {

        state = BoxScreenState(plants: boxPlants, decors: boxDecor)
    }
}
