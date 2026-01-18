//
//  SystemBlur.swift
//  TimeToSow
//
//  Created by Nebo on 19.01.2026.
//

import UIKit
import SwiftUI

struct SystemBlur: UIViewRepresentable {
    
    var style: UIBlurEffect.Style = .systemChromeMaterialLight
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return blur
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
