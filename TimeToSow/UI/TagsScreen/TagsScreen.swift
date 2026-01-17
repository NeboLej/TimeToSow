//
//  TagsScreen.swift
//  TimeToSow
//
//  Created by Nebo on 17.01.2026.
//

import SwiftUI

struct TagsScreen: View {
    @Environment(\.dismiss) var dismiss
    
    @State var store: TagsScreenStore
    @State var currentTag: Tag? = nil
    @State var mode: PresentationDetent = .fraction(0.3)
    
    init(store: TagsScreenStore) {
        self.store = store
    }
    
    var body: some View {
        VStack {

            if store.state.mode == .list {
                Picker(selection: $currentTag) {
                    ForEach(store.state.tagsList) {
                        TagView(tag: $0).tag($0)
                    }
                } label: {}.pickerStyle(.inline)
            } else {
                EmptyView()
            }

            
            HStack {
                
                Button {
                    store.send(.changeMode(.addNewTag))
                } label: {
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                TextureButton(label: "Save", color: .accentColor) {
                    if let currentTag {
                        store.send(.selectTag(currentTag))
                        dismiss()
                    }
                }
            }

        }
        .presentationDetents([.fraction(0.3), .medium], selection: $mode)
        .presentationDragIndicator(.visible)
        .onChange(of: store.state.mode) { _, newValue in
            mode = newValue == .addNewTag ? .medium : .fraction(0.3)
        }
    }
}

#Preview {
    screenBuilderMock.getScreen(type: .tags)
}
