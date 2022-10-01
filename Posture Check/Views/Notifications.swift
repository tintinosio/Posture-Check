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
        // Exercise Notifications
        case postureReminder, exercise, restReminder
        // Questionnaire Notifications
        case oneTime, everyFifteenDays, startAndEnd, daily, satisfaction
    }
    
    var userHasGrantedPermissions: Bool {
        let center = UNUserNotificationCenter.current()
        var status = false
        
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
                
            case .notDetermined:
                status = false
            case .denied:
                status = false
            case .authorized:
                status = true
            case .provisional:
                status = false
            case .ephemeral:
                status = false
            @unknown default:
                status = false
            }
        }
        
        return status
    }
    
    func getNotificationTitle(of notificationType: NotificationType) -> String {
        switch notificationType {
        case .postureReminder:
            return "Posture Reminder"
        case .exercise:
            return "Exercise time 🧘🏻‍♂️"
        case .restReminder:
            return "Rest Reminder 💤"
        default:
            return "" // To be set
        }
    }
    
    func getNotificationDescription(of notificationType: NotificationType) -> String {
        switch notificationType {
        case .postureReminder:
            return "remember to maintain the phone at eye level to avoid tech neck syndrome"
        case .exercise:
            return "Long press the notification to mark as completed or view exercise instructions"
        case .restReminder:
            return "A rest of 20 minutes is recommended for this period of usage"
        default:
            return "A new questionnaire is available!"
        }
    }
    
    func generateNotifications() {
        generateNotificationsOf(type: .postureReminder)
        //        generateNotificationsOf(type: .exercise)
        //        generateNotificationsOf(type: .restReminder)
    }
    
    func generateNotificationsOf(type: NotificationType) {
        let notificationTitle = getNotificationTitle(of: type)
        let notificationSub = getNotificationDescription(of: type)
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.subtitle = notificationSub
        content.sound = .default
        
        for _ in 0...63 {
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
            
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    func requestForAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("User allowed notifications")
            } else if let error = error {
                print(error.localizedDescription)
            } else {
                print("User has notifications off!")
            }
        }
    }
    
//    func notificationContentGenerator() -> UNMutableNotificationContent {
//
//    }
    // MARK: Developer Functions - Use the functions for testing only!
    
    func devgenerateNotificationsOf(type: NotificationType) {
        let notificationTitle = getNotificationTitle(of: type)
        let notificationSub = getNotificationDescription(of: type)
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.subtitle = notificationSub
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                UNUserNotificationCenter.current().add(request)
            } else {
                print("Notification could not be added")
            }
        }
    }

    @MainActor func devgenerateNotificationOfExercise() {
        let center = UNUserNotificationCenter.current()
        
        let notificationTitle = getNotificationTitle(of: .exercise)
        let notificationSub = getNotificationDescription(of: .exercise)
        let exerciseForNotification = Exercises().available.randomElement()!
        
        let markAsCompleteAction = UNNotificationAction(identifier: "exerciseCompleted", title: "Mark as Completed")
        let viewGifAction = UNNotificationAction(identifier: "viewGif", title: "View exercise instructions")

        let category = UNNotificationCategory(identifier: "exerciseCategory", actions: [markAsCompleteAction, viewGifAction], intentIdentifiers: [""])
        center.setNotificationCategories([category])
        
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.subtitle = notificationSub
        content.sound = .default
        content.categoryIdentifier = "exerciseCategory"
        guard let imageURL = Bundle.main.url(forResource: exerciseForNotification.icon, withExtension: "png") else {
            print("Image not found!")
            return
        }
       
        let attachment = try! UNNotificationAttachment(identifier: exerciseForNotification.icon, url: imageURL, options: .none)
        
        content.attachments = [attachment]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                UNUserNotificationCenter.current().add(request)
            } else {
                print("Notification could not be added")
            }
        }
    }
}

//    func addNotification(type: NotificationType, imageName: String) {
//        let center = UNUserNotificationCenter.current()
//        
//        let completedAction = UNNotificationAction(identifier: "exerciseCompleted", title: "Mark as completed")
//        let viewGifAction = UNNotificationAction(identifier: "viewGif", title: "View exercise instructions")
//        
//        let category = UNNotificationCategory(identifier: "exerciseCategory", actions: [completedAction, viewGifAction], intentIdentifiers: [""])
//        center.setNotificationCategories([category])
//        
//        let addRequest = {
//            let content = UNMutableNotificationContent()
//            content.title = notificationTitle
//            content.subtitle = notificationSub
//            content.sound = UNNotificationSound.default
//            content.categoryIdentifier = "exerciseCategory"
//            guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "jpeg") else {
//                print("Image not found!")
//                return
//            }
//            
//            let attachment = try! UNNotificationAttachment(identifier: imageName, url: imageURL, options: .none)
//            
//            content.attachments = [attachment]
//            
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 4, repeats: false)
//            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//            
//            center.add(request)
//        }
//        
//        center.getNotificationSettings { settings in
//            if settings.authorizationStatus == .authorized {
//                addRequest()
//            } else {
//                center.requestAuthorization(options: [.sound, .badge, .alert]) { success, error in
//                    if success {
//                        addRequest()
//                    } else {
//                        print("Not approved")
//                    }
//                }
//            }
//        }
//    }
