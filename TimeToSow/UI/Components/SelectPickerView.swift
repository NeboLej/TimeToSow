//
//  SelectPickerView.swift
//  TimeToSow
//
//  Created by Nebo on 18.05.2025.
//

import SwiftUI

enum PickerElement: Int, Identifiable, CaseIterable {
    
    case new = 0, upgrade = 1
    
    var id: Int { rawValue }
    
    var name: String {
        switch self {
        case .new: "plant"
        case .upgrade: "green"
        }
    }
}

struct SelectPickerView: View {
    @Binding var selectedElement: PickerElement
    @State var pickerElements: [PickerElement] = PickerElement.allCases
        
    var body: some View {
        HStack {
            ForEach(pickerElements, id: \.id) { element in
                TextEllipseStrokeView(text: element.name, isSelected: element == selectedElement)
                    .font(.caption)
                    .foregroundColor(element == selectedElement ? .strokeAcsent : .strokeAcsent.opacity(0.9))
                    .onTapGesture {
                        selectedElement = element
                    }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedElement: PickerElement = .new
    SelectPickerView(selectedElement: $selectedElement)
}
