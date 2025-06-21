//
//  Collection.swift
//  TimeToSow
//
//  Created by Nebo on 21.06.2025.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
