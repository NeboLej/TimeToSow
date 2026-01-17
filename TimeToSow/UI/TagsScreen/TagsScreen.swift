//
//  TagsScreen.swift
//  TimeToSow
//
//  Created by Nebo on 17.01.2026.
//

import SwiftUI

struct TagsScreen: View {
    
    @State var store: TagsScreenStore
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    screenBuilderMock.getScreen(type: .tags)
}
