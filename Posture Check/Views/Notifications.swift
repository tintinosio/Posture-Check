//
//  Notifications.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 9/6/22.
//

import Foundation
import UserNotifications


class Notifications: ObservableObject {
    enum NotificationType {
        case twentyMinutes, getUp, move // TODO: Review this against client requirements Hint: WhatsApp - Luis
    }
    
    func addNotification(type: NotificationType, imageName: String) {
        let center = UNUserNotificationCenter.current()
        var notificationTitle = ""
        var notificationSub = ""
        
        switch type {
        case .twentyMinutes:
            notificationTitle = "20 minute notification 🤳"
            notificationSub = "Hey... eyes up!"
        case .getUp:
            notificationTitle = "Time to get up! 🚶"
            notificationSub = "Neck or back pain? Keep it straight."
        case .move:
            notificationTitle = "Time to move! 🏃"
            notificationSub = "Posture is important. Be mindful!"
        }
        
        let completedAction = UNNotificationAction(identifier: "exerciseCompleted", title: "Mark as completed")
        let viewGifAction = UNNotificationAction(identifier: "viewGif", title: "View exercise instructions")
        
        let category = UNNotificationCategory(identifier: "exerciseCategory", actions: [completedAction, viewGifAction], intentIdentifiers: [""])
        center.setNotificationCategories([category])
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = notificationTitle
            content.subtitle = notificationSub
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "exerciseCategory"
            guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "jpeg") else {
                print("Image not found!")
                return
            }
            
            let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
            
            content.attachments = [attachment]
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.sound, .badge, .alert]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Not approved")
                    }
                }
            }
        }
    }
}
