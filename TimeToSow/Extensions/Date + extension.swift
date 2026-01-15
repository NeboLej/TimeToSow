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
    
    func toMonthYearDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        
        return formatter.string(from: self)
    }
    
    func isCurrentMonth() -> Bool {
        Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }
    
    func getOffsetDate(offset: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: offset, to: self) ?? Date()
    }
}
