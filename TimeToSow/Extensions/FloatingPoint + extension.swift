//
//  FloatingPoint + extension.swift
//  TimeToSow
//
//  Created by Nebo on 14.01.2026.
//

import Foundation

extension FloatingPoint {
    func isAlmostEqual(to other: Self, tolerance: Self = 0.00001) -> Bool {
        abs(self - other) <= tolerance
    }
}
