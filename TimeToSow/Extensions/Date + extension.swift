//
//  Date + extension.swift
//  TimeToSow
//
//  Created by Nebo on 26.12.2025.
//

import Foundation

extension Date {
    func toReadableDate() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        return formatter.string(from: self)
    }
    
    func getOffsetDate(offset: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: offset, to: self) ?? Date()
    }
}
