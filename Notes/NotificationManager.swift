//
//  NotificationManager.swift
//  Notes
//
//  Created by Илья Аникин on 02.07.2022.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    
    override init() {
        super.init()
        self.registerForPushNotifications()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge],
                                  completionHandler: { _, _ in })
    }
    
    func scheduleNotification(note: NoteDataModel) {
        guard let scheduled = note.scheduled else { return }
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] list in
            //check if notification is already scheduled
            for item in list {
                if item.identifier == "\(note.id)" {
                    self?.removeScheduledNotification(noteid: item.identifier)
                    break
                }
            }
            
            //schedule
            let content = UNMutableNotificationContent()
            content.title = note.title ?? "Notification"
            content.body = note.description ?? ""
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents(
                [.day, .month, .year, .hour, .minute],
                from: scheduled), repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "\(note.id)",
                content: content,
                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print(error)
                }
            }
        }
    }
    
    func removeScheduledNotification(noteid: Int) {
        removeScheduledNotification(noteid: "\(noteid)")
    }
    
    func removeScheduledNotification(noteid: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [noteid])
    }
}
