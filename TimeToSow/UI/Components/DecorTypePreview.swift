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
    @State private var isAnimating: Bool = false
    
    private let zoomCoef: CGFloat
    private let animationOptions: AnimationOptions?
    private let height: CGFloat
    private let resourceUrl: URL?
    
    init(decorType: DecorType, zoom: CGFloat = 1, isDragging: Binding<Bool> = .constant(false)) {
        self._isDragging = isDragging
        self.zoomCoef = zoom
        animationOptions = decorType.animationOptions
        height = decorType.height
        resourceUrl = decorType.resourceUrl
    }
    
    init(decorModel: DecorModel, zoom: CGFloat = 1) {
        self._isDragging = .constant(false)
        self.zoomCoef = zoom
        animationOptions = decorModel.animationOptions
        height = decorModel.height
        resourceUrl = decorModel.imageUrl
    }
    
    var body: some View {
        if let animation = animationOptions {
            AnimatedImage(url: resourceUrl, isAnimating: $isAnimating)
                .customLoopCount(animation.repeatCount)
                .resizable()
                .scaledToFit()
                .frame(height: height * zoomCoef)
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
            WebImage(url: resourceUrl)
                .resizable()
                .scaledToFit()
                .frame(height: height * zoomCoef)
        }
    }
}
