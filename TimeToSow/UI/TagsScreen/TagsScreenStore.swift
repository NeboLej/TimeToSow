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
            case .changeMode(let mode):
                self.mode = mode
                rebuildState()
            case .addNewTag(let name, let color):
                let newTag = Tag(name: name, color: color)
                allTags.append(newTag)
                appStore.send(.newTag(newTag))
                appStore.send(.selectTag(newTag))
            case .selectTag(let tag):
                appStore.send(.selectTag(tag))
            case .deleteTag(let tag):
                if tag.stableId == DefaultModels.tags.first?.stableId { return } //TODO: alert
                allTags.removeAll(where: { $0 == tag })
                rebuildState()
                appStore.send(.deleteTag(tag))
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
        let sordedTags: [Tag]
        if let currentTag = appStore.selectedTag {
            sordedTags = [currentTag] + allTags.filter { $0.id != currentTag.id }
        } else {
            sordedTags = allTags
        }
        state = TagsScreenState(mode: mode, tagsList: sordedTags, selectedTag: appStore.selectedTag)
    }
}
