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
    @State var mode: PresentationDetent = .fraction(0.4)
    
    @State var newTagName: String = ""
    @State var tagSize: CGSize = .zero
    @State var newTagColor: Color = .blue
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
                HStack {
                    Spacer()
                    Button {
                        store.send(.changeMode(.addNewTag))
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }.padding(.horizontal, 24)
                        .padding(.top, 16)
                }
                Picker(selection: $currentTag) {
                    ForEach(store.state.tagsList) {
                        TagView(tag: $0).tag($0)
                    }
                } label: {}.pickerStyle(.inline)
            } else {
                
                TagView(tag: newTag)
                    .id(newTag)
                    .padding(.top, 40)
                    .scaleEffect(1.8)
                
                Form {
                    Section {
                        colorPicker()
                            .onTapGesture {
                                isShowColorPicker = true
                            }
                        TextField("New tag name", text: $newTagName)
                    }
                }
                .scrollContentBackground(.hidden)
                Spacer()
            }
            
            HStack {
                TextureButton(label: "Save", color: .accentColor) {
                    if store.state.mode == .addNewTag {
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
        .modifier(CustomBackgroundModifier())
    }
    
    @ViewBuilder func colorPicker() -> some View {
        HStack {
            Text("Choose a color")
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

fileprivate struct CustomBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
        } else {
            content
                .presentationBackground {
                    SystemBlur()
                        .ignoresSafeArea()
                }
        }
    }
}

#Preview {
    screenBuilderMock.getScreen(type: .tags)
}
