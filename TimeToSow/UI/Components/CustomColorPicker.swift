//
//  CustomColorPicker.swift
//  TimeToSow
//
//  Created by Nebo on 19.01.2026.
//

import SwiftUI
import UIKit

struct CustomColorPicker: UIViewControllerRepresentable {
    @Binding var color: Color
    var supportsAlpha: Bool = true
    
    // ← вот здесь можно ловить события
    var onPresent:  (() -> Void)?
    var onDismiss: (() -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIColorPickerViewController {
        let picker = UIColorPickerViewController()
        picker.supportsAlpha = false
        picker.delegate = context.coordinator
        picker.selectedColor = UIColor(color)
        return picker
    }
    
    func updateUIViewController(_ uiVC: UIColorPickerViewController, context: Context) {
        uiVC.selectedColor = UIColor(color)
    }
    
    class Coordinator: NSObject, UIColorPickerViewControllerDelegate {
        var parent: CustomColorPicker
        
        init(_ parent: CustomColorPicker) {
            self.parent = parent
        }
        
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            parent.onDismiss?()
        }
        
        func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
            parent.color = Color(viewController.selectedColor)
        }
    }
}
