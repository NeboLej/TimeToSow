//
//  LocalNotificationService.swift
//  TimeToSow
//
//  Created by Nebo on 05.02.2026.
//

import Foundation
import NotificationCenter

protocol LocalNotificationServiceProtocol {
    func add(_ notification: LocalNotification)
    func deleteAll(withType: LocalNotificationType)
}

final class LocalNotificationService: LocalNotificationServiceProtocol {
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func add(_ notification: LocalNotification) {
        
        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.message
        
        content.userInfo = ["notificationInfo": notification.type.rawValue]
//        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "NotificationSound.wav"))
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notification.dispatchDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: notification.type.rawValue, content: content, trigger: trigger)
        
        self.notificationCenter.add(request) {
            if let error = $0 {
                Logger.log("Error added Notification", location: .notificationCenter, event: .error(error))
            } else {
                Logger.log("Success added Notification", location: .notificationCenter, event: .success)
            }
        }
    }
    
    func deleteAll(withType: LocalNotificationType) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [withType.rawValue])
    }
}
