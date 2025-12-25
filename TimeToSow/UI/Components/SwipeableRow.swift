//
//  SwipeableRow.swift
//  TimeToSow
//
//  Created by Nebo on 26.12.2025.
//

import SwiftUI

struct SwipeableRow<Content: View, Actions: View>: View {
    let content: Content
    let actions: Actions
    
    @State private var offset: CGFloat = 0
    
    init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder actions: () -> Actions
    ) {
        self.content = content()
        self.actions = actions()
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            actions
            
            content
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation {
                                offset = min(0, value.translation.width)
                            }
                        }
                        .onEnded { value in
                            withAnimation {
                                if value.translation.width < -80 {
                                    offset = -120
                                } else {
                                    offset = 0
                                }
                            }
                        }
                )
        }
    }
}
