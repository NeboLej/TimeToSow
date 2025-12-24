//
//  RarityView.swift
//  TimeToSow
//
//  Created by Nebo on 25.12.2025.
//

import SwiftUI

struct RarityView: View {
    
    @State var count: Int
    
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            ForEach(0..<count, id: \.self) { _ in
                Image(.starIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
    }
}

#Preview {
    RarityView(count: 4)
        .frame(height: 20)
}
