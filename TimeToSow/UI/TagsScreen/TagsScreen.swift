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
    @State private var currentTag: Tag? = nil
    @State private var mode: PresentationDetent = .fraction(0.4)
    
    @State private var newTagName: String = ""
    @State private var newTagColor: Color = .blue
    @State private var isShowDeleteAllert: Bool = false
    @State private var defaultTag = DefaultModels.tags.first
    @State private var isShowColorPicker = false {
        didSet {
            if isShowColorPicker {
                mode = .large
            }  else {
                mode = .fraction(0.4)
            }
        }
    }
    
    var newTag: Tag {
        Tag(name: newTagName.isEmpty ? "new tag" : newTagName, color: newTagColor.toHex())
    }
    
    init(store: TagsScreenStore) {
        self.store = store
    }
    
    var body: some View {
        VStack {
            if store.state.mode == .list {
                HStack(alignment: .center, spacing: 8) {
                    Spacer()
                    if currentTag?.stableId != defaultTag?.stableId {
                        Button {
                            isShowDeleteAllert = true
                        } label: {
                            Image(systemName: "trash.circle")
                                .resizable()
                                .foregroundStyle(Color.red.opacity(0.8))
                                .frame(width: 29, height: 29)
                        }
                    }
                    Button {
                        store.send(.changeMode(.addNewTag))
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                Picker(selection: $currentTag) {
                    ForEach(store.state.tagsList) { tag in
                        TagView(tag: tag).tag(Optional(tag))
                    }
                } label: {}.pickerStyle(.inline)
            } else {
                TagView(tag: newTag)
                    .background(.white)
                    .cornerRadius(30, corners: .allCorners)
                    .padding(.top, 40)
                    .scaleEffect(1.8)
                    .id(newTag)
                
                Form {
                    Section {
                        colorPicker()
                            .onTapGesture {
                                isShowColorPicker = true
                            }
                            .listRowBackground(Color.white.opacity(0.8))
                        
                        TextField("", text: $newTagName,
                                  prompt: Text("New tag name")
                            .foregroundStyle(.black.opacity(0.5))
                        )
                        .foregroundStyle(.black)
                        .listRowBackground(Color.white.opacity(0.8))
                    }
                }
                .scrollContentBackground(.hidden)
                Spacer()
            }
            
            HStack {
                TextureButton(label: "Save", color: .accentColor) {
                    if store.state.mode == .addNewTag, !newTagName.isEmpty {
                        store.send(.addNewTag(name: newTagName, color: newTagColor.toHex()))
                    } else if store.state.mode == .list, let currentTag {
                        store.send(.selectTag(currentTag))
                    }
                    dismiss()
                }.padding(.bottom, 16)
            }
        }
        .presentationDetents([.fraction(0.4), .large], selection: $mode)
        .presentationDragIndicator(.visible)
        .ignoresSafeArea(.all, edges: .bottom)
        .presentationBackground(.mainBackground)
        .onAppear {
            currentTag = store.state.selectedTag
        }
        .onChange(of: store.state.selectedTag) { oldValue, newValue in
            currentTag = store.state.selectedTag
        }
        .alert("Удалить этот тег? \nПри удалении тэг останется истории связанных с ним записей", isPresented: $isShowDeleteAllert) {
            Button(role: .destructive) {
                if let currentTag {
                    store.send(.deleteTag(currentTag))
                }
            } label: {
                Text("Удалить")
            }
            Button(role: .cancel) { } label: {
                Text("Отмена")
            }
        }
    }
    
    @ViewBuilder func colorPicker() -> some View {
        HStack {
            Text("Choose a color")
                .foregroundStyle(.black)
            Spacer()
            Circle()
                .fill(newTagColor).frame(width: 30, height: 30)
        }.sheet(isPresented: $isShowColorPicker, onDismiss: {
            isShowColorPicker = false
        }, content: {
            CustomColorPicker(color: $newTagColor)
                .scrollDisabled(true)
                .presentationDetents([.fraction(0.51)])
        })
    }
}

#Preview {
    screenBuilderMock.getScreen(type: .tags)
}
