//
//  ScrollViewSwipeActionModifier.swift
//  TimeToSow
//
//  Created by Nebo on 14.01.2026.
//

import SwiftUI

struct ScrollViewSwipeActionModifier: ViewModifier {
    
    @State private var size: CGSize = .init(width: 1, height: 1)
    
    func body(content: Content) -> some View {
        List {
            LazyVStack {
                content
            }
            .frame(minHeight: 44)
            .readSize { contentSize in
                size = contentSize
            }
            .listRowInsets(EdgeInsets())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
        }
        .scrollDisabled(true)
        .listStyle(.plain)
        .frame(height: size.height)
        .contentMargins(.vertical, EdgeInsets())
    }
}

