//
//  DecorTypePreview.swift
//  TimeToSow
//
//  Created by Nebo on 04.02.2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct DecorTypePreview: View {
    
    @Binding private var isDragging: Bool
    @State private var decor: DecorType
    @State private var isAnimating: Bool = false
    @State private var zoomCoef: CGFloat
    
    init(decorType: DecorType, zoom: CGFloat = 1, isDragging: Binding<Bool> = .constant(false)) {
        self._isDragging = isDragging
        self.decor = decorType
        self.zoomCoef = zoom
    }
    
    var body: some View {
        if let animation = decor.animationOptions {
            AnimatedImage(url: decor.resourceUrl, isAnimating: $isAnimating)
                .customLoopCount(animation.repeatCount)
                .resizable()
                .scaledToFit()
                .frame(height: decor.height * zoomCoef)
                .onAppear {
                    let randomTime = Double.random(in: 1...animation.timeRepetition)
                    DispatchQueue.main.asyncAfter(deadline: .now() + randomTime) {
                        self.isAnimating = true
                    }
                }
                .onChange(of: isAnimating) { oldValue, newValue in
                    DispatchQueue.main.asyncAfter(deadline: .now() + animation.timeRepetition / 2) {
                        self.isAnimating = oldValue
                    }
                }.onChange(of: isDragging) { oldValue, newValue in
                    if newValue {
                        isAnimating = false
                    }
                }
        } else {
            WebImage(url: decor.resourceUrl)
                .resizable()
                .scaledToFit()
                .frame(height: decor.height * zoomCoef)
        }
    }
}
