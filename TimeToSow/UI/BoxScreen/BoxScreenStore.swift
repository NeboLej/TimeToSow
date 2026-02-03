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
    
    @ObservationIgnored
    private let decorRepository: DecorRepositoryProtocol
    
    private var boxPlants: [Plant] = []
    private var currentDecor: [Decor] = []
    private var decorTypes: [DecorType] = []
    
    init(appStore: AppStore, decorRepository: DecorRepositoryProtocol) {
        self.decorRepository = decorRepository
        super.init(appStore: appStore)
        
        let plants = appStore.currentRoom.plants
        
        boxPlants = plants.filter { !$0.value.isOnShelf }.map { $0.value }.sorted(by: { $1.dateCreate > $0.dateCreate })
        currentDecor = appStore.currentRoom.decor.map { $0.value }
        
        getData()
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
    
    private func getData() {
        Task {
            decorTypes = await decorRepository.getAllDecorTypes()
            rebuildState()
        }
    }
    
    //MARK: - Private
    private func handle(_ action: BoxScreenAction) {
        switch action {
        case .toShelfPlant(let plant):
            boxPlants.removeAll(where: { plant == $0 })
            rebuildState()
        case .toShelfDecor(let decor):
            currentDecor.removeAll(where: { decor.id == $0.decorType.id })
            rebuildState()
        default: break
        }
    }
    
    private func appStoreSend(_ action: BoxScreenAction) {
        switch action {
        case .toShelfPlant(let plant):
            appStore.send(.changeShelfVisibility(plant: plant, isVisible: true))
        case .toShelfDecor(let decor):
            appStore.send(.addNewDecorToShelf(decor))
        case .infoPlant(let plant):
            appStore.send(NavigateAction.toDetailPlant(plant))
        case .infoDecor(let decor): break
        }
    }
    
    private func rebuildState() {

        let filtredDecorTypes = decorTypes.filter { type in
            currentDecor.contains { decor in
                decor.decorType.id == type.id
            }
        }
        
        state = BoxScreenState(plants: boxPlants, decors: filtredDecorTypes)
    }
}
