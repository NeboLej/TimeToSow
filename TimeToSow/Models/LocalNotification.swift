//
//  LocalNotification.swift
//  TimeToSow
//
//  Created by Nebo on 05.02.2026.
//

import Foundation

struct LocalNotification {
    let title: String
    let message: String
    let dispatchDate: Date
    let type: LocalNotificationType
    
    init(title: String, message: String, dispatchDate: Date, type: LocalNotificationType) {
        self.title = title
        self.message = message
        self.dispatchDate = dispatchDate
        self.type = type
    }
    
    init(type: LocalNotificationType, minutes: Int) {
        self.title = type.title
        self.message = type.message
        self.dispatchDate = Date().getOffsetDate(minutes, component: .minute)
        self.type = type
    }
}

enum LocalNotificationType: String {
    case taskCompleted
    
    var title: String {
        switch self {
        case .taskCompleted:
            return "Time To Sow"
        }
    }
    
    var message: String {
        switch self {
        case .taskCompleted:
            return "Task completed"
        }
    }
}
