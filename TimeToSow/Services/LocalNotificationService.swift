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
        Task {
            let granted = await requestPermissionIfNeeded()
            guard granted else {
                Logger.log("Notification permission denied", location: .notificationCenter, event: .error(nil))
                return
            }
            
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.body = notification.message
            
            content.userInfo = ["notificationInfo": notification.type.rawValue]
            
            //        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "NotificationSound.wav"))
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notification.dispatchDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: notification.type.rawValue, content: content, trigger: trigger)
            
            do {
                try await notificationCenter.add(request)
                Logger.log("Success added Notification", location: .notificationCenter, event: .success)
            } catch {
                Logger.log("Error added Notification", location: .notificationCenter, event: .error(error))
            }
        }
    }
    
    func deleteAll(withType: LocalNotificationType) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [withType.rawValue])
        Logger.log("Deleted notification \(withType.rawValue)", location: .notificationCenter, event: .success)
    }
    
    private func requestPermissionIfNeeded() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        switch settings.authorizationStatus {
        case .authorized, .provisional:
            Logger.log("Уведомления разрешены ✅", location: .notificationCenter, event: .unowned)
            return true
        case .notDetermined:
            Logger.log("Разрешение ещё не запрашивали 🤔", location: .notificationCenter, event: .unowned)
            do {
                let isAllowed = try await center.requestAuthorization(options: [.alert, .badge, .sound])
                Logger.log("Пользователь \(isAllowed ? "РАЗРЕШИЛ" : "ЗАПРЕТИЛ") отправку уведомлений", location: .notificationCenter, event: .unowned)
                return isAllowed
            } catch {
                return false
            }
        case .denied:
            Logger.log("Уведомления запрещены ❌", location: .notificationCenter, event: .unowned)
            return false
        case .ephemeral:
            Logger.log("Временное (App Clip)", location: .notificationCenter, event: .unowned)
            return false
        @unknown default:
            return false
        }
    }
}
