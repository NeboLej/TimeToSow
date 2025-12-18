//
//  Int + extension.swift
//  TimeToSow
//
//  Created by Nebo on 19.12.2025.
//

import Foundation

extension Int {
    func toHoursAndMinutes() -> String {
        let hours = self / 60
        let minutes = self % 60
        
        var result: String = ""
        
        if hours > 0 {
            result.append("\(hours)h")
        }
        
        if minutes > 0 {
            result.append(" \(minutes)min")
        }
        
        if result.isEmpty {
            result.append("0 min")
        }
        
        return result
    }
}
