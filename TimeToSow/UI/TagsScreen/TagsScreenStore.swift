//
//  TagsScreenStore.swift
//  TimeToSow
//
//  Created by Nebo on 17.01.2026.
//

import SwiftUI

@Observable
final class TagsScreenStore: FeatureStore {
    
    @ObservationIgnored
    private let tagRepository: TagRepositoryProtocol
    
    var state: TagsScreenState
    
    private var mode: TagsScreenState.Mode = .list
    private var allTags: [Tag] = []

    init(appStore: AppStore, tagRepository: TagRepositoryProtocol) {
        self.tagRepository = tagRepository
        state = TagsScreenState(mode: .list, tagsList: [], selectedTag: appStore.selectedTag)
        
        super.init(appStore: appStore)
        
        getData()
    }
    
    func send(_ action: TagsScreenAction, animation: Animation? = nil) {
        withAnimation(animation) {
            switch action {
            case .changeMode(let mode): break
            case .addNewTag(let name, let color): break
            case .selectTag(let tag): break
            }
        }
    }
    
    func getData() {
        Task {
            allTags = await tagRepository.getAllTags()
            rebuildState()
        }
    }
    
    private func rebuildState() {
        state = TagsScreenState(mode: mode, tagsList: allTags, selectedTag: appStore.selectedTag)
    }
}
