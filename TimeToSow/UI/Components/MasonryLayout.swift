//
//  MasonryLayout.swift
//  TimeToSow
//
//  Created by Nebo on 28.01.2026.
//

import SwiftUI

struct MasonryLayout: Layout {
    let columns: Int
    let spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        let columnWidth = (width - spacing * CGFloat(columns - 1)) / CGFloat(columns)
        
        var heights = Array(repeating: CGFloat.zero, count: columns)
        
        for view in subviews {
            let size = view.sizeThatFits(.init(width: columnWidth, height: nil))
            let column = heights.firstIndex(of: heights.min()!)!
            heights[column] += size.height + spacing
        }
        
        return CGSize(width: width, height: heights.max() ?? 0)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let columnWidth = (bounds.width - spacing * CGFloat(columns - 1)) / CGFloat(columns)
        
        let xOffsets: [CGFloat] = (0..<columns).map {
            CGFloat($0) * (columnWidth + spacing)
        }
        var yOffsets = Array(repeating: CGFloat.zero, count: columns)
        
        for view in subviews {
            let size = view.sizeThatFits(.init(width: columnWidth, height: nil))
            let column = yOffsets.firstIndex(of: yOffsets.min()!)!
            
            view.place(
                at: CGPoint(x: xOffsets[column], y: yOffsets[column]),
                proposal: .init(width: columnWidth, height: size.height)
            )
            
            yOffsets[column] += size.height + spacing
        }
    }
}
