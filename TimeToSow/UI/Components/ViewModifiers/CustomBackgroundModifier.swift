//
//  CustomBackgroundModifier.swift
//  TimeToSow
//
//  Created by Nebo on 20.01.2026.
//

import SwiftUI

struct CustomBackgroundModifier: ViewModifier {
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
