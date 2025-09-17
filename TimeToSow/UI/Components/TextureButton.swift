//
//  TextureButton.swift
//  TimeToSow
//
//  Created by Nebo on 17.09.2025.
//

import SwiftUI

struct TextureButton: View {
    
    private let label: String?
    private let icon: Image?
    private let color: Color
    private let action: () -> ()
    
    @GestureState private var isPressed = false
    @State private var animation: Bool = false
    
    init(label: String, color: Color = .white, icon: Image? = nil, action: @escaping () -> ()) {
        self.color = color
        self.icon = icon
        self.label = label
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            TextureView(
                insets: .init(top: 8, leading: 18, bottom: 8, trailing: 18),
                texture: Image(.smallTexture1),
                color: color,
                cornerRadius: 50
            ) {
                HStack(spacing: 8) {
                    if let icon {
                        icon
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                    }
                    if let label {
                        Text(label)
                            .font(.myTitle(24))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .buttonStyle(PressableStyle())
    }
}

struct PressableStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

#Preview {
    VStack {
        TextureButton(label: "Start",
                      color: .green,
                      icon: Image(.deleteAnimation2)) {
            print("asdasd")}
    }
}
