//
//  DecorPreview.swift
//  TimeToSow
//
//  Created by Nebo on 25.01.2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct DecorPreview: View {
    
    @State var zoomCoef: CGFloat = 2.5
    @State var decor: Decor
    
    var body: some View {
        WebImage(url: decor.decorType.resourceUrl)
            .resizable()
            .scaledToFit()
            .padding()
            .frame(height: decor.decorType.height * zoomCoef)
        
//        if name.contains(".gif") {
//            AnimatedImage(name: name, bundle: .main)
//                .resizable()
//                .customLoopCount(rewardDecor.animationOptions?.repeatCount ?? 1)
//                .scaledToFit()
//                .padding()
////                            .frame(width: rewardDecor.width * 1.7)
//        } else {
//
//        }
    }
}

struct DecorTypePreview: View {
    
    @State var zoomCoef: CGFloat = 2.5
    @State var decor: DecorType
    
    var body: some View {
        WebImage(url: decor.resourceUrl)
            .resizable()
            .scaledToFit()
            .padding()
            .frame(height: decor.height * zoomCoef)
        
//        if name.contains(".gif") {
//            AnimatedImage(name: name, bundle: .main)
//                .resizable()
//                .customLoopCount(rewardDecor.animationOptions?.repeatCount ?? 1)
//                .scaledToFit()
//                .padding()
////                            .frame(width: rewardDecor.width * 1.7)
//        } else {
//
//        }
    }
}
