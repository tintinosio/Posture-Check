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
            return Constants.postureRemindersTitles.randomElement() ?? "Posture Reminder"
            
        case .exercise:
            return Constants.exercisesRemindersTitles.randomElement() ?? "Exercise time 🧘🏻‍♂️"
            
        case .restReminder:
            return Constants.restReminderTitles.randomElement() ?? "Rest Reminder 💤"
            
        default:
            return "" // To be set
        }
    }
    
    func getNotificationDescription(of notificationType: NotificationType) -> String {
        switch notificationType {
        case .postureReminder:
            return Constants.postureRemindersDescriptions.randomElement() ?? "Remember to maintain the phone at eye level to avoid tech neck syndrome"
            
        case .exercise:
            return Constants.exercisesRemindersDescription.randomElement() ?? "Long press the notification to mark as completed or view exercise instructions"
            
        case .restReminder:
            return Constants.restReminderDescription.randomElement() ?? "A rest of 20 minutes is recommended for this period of usage"
            
        default:
            return "A new questionnaire is available!"
        }
    }
    
    func generateNotifications() async {
        await generateNotificationsOf(type: .postureReminder)
        await generateNotificationsOf(type: .exercise)
        await generateNotificationsOf(type: .restReminder)
    }
    
    func generateNotificationsOf(type notificationType: NotificationType) async {
        
        let content = await generateNotificationContentFor(notificationType)
       
        let triggers = await getTriggersFor(notificationType)

        for trigger in triggers {
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            do {
                try await UNUserNotificationCenter.current().add(request)
            } catch {
                fatalError("Could not schedule alerts")
            }
        }
    }
    
    func generateNotificationContentFor(_ type: NotificationType) async -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = getNotificationTitle(of: type)
        content.subtitle = getNotificationDescription(of: type)
        content.sound = .default
        
        if type == .exercise {
            let exerciseForNotification = await Exercises().available.randomElement()! //MARK: Todo - check if you can avoid repeating exercises
            
            let completedAction = UNNotificationAction(identifier: "exerciseCompleted", title: "Mark as completed")
            
            let viewGifAction = UNNotificationAction(identifier: "viewGif", title: "View exercise instructions")
            
            let category = UNNotificationCategory(identifier: "exerciseCategory", actions: [completedAction, viewGifAction], intentIdentifiers: [""])
            
            UNUserNotificationCenter.current().setNotificationCategories([category])
            
            content.categoryIdentifier = "exerciseCategory"
            
            let imageURL = Bundle.main.url(forResource: exerciseForNotification.icon, withExtension: "png")!
            
            let attachment = try! UNNotificationAttachment(identifier: exerciseForNotification.icon, url: imageURL)
            
            content.attachments = [attachment]
        }
        
        return content
    }
    
    func getTriggersFor(_ type: NotificationType) async -> [UNCalendarNotificationTrigger] {
        let startDate = await Calendar.autoupdatingCurrent.date(from: AppSettings().activeFrom) ?? Date.now
        let endDate = await Calendar.autoupdatingCurrent.date(from: AppSettings().activeUpTo) ?? Date.now.addingTimeInterval(3600)
        var triggers = [UNCalendarNotificationTrigger]()
        
        switch type {
        case .postureReminder:
            for index in 1..<maxNotificationAllowedBetween(startDate, and: endDate, type: type) + 1 {
                let offsetedDate = startDate.addingTimeInterval(Double(index) * Constants.postureReminderOffset)
                print(offsetedDate.formatted())
                let offsettedDateComponents = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute], from: offsetedDate)
                triggers.append(
                    UNCalendarNotificationTrigger(dateMatching: offsettedDateComponents, repeats: true)
                )
            }
            
        case .exercise:
            for index in 1..<maxNotificationAllowedBetween(startDate, and: endDate, type: type) + 1 {
                let offsetedDate = startDate.addingTimeInterval(Double(index) * Constants.exerciseReminderOffset)
                print(offsetedDate.formatted())
                let offsettedDateComponents = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute], from: offsetedDate)
                triggers.append(
                    UNCalendarNotificationTrigger(dateMatching: offsettedDateComponents, repeats: true)
                )
            }
            
        case .restReminder:
            for index in 1..<maxNotificationAllowedBetween(startDate, and: endDate, type: type) + 1 {
                let offsetedDate = startDate.addingTimeInterval(Double(index) * Constants.restReminderOffset)
                print(offsetedDate.formatted())
                let offsettedDateComponents = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute], from: offsetedDate)
                triggers.append(
                    UNCalendarNotificationTrigger(dateMatching: offsettedDateComponents, repeats: true)
                )
            }
            
        case .oneTime:
            break
        case .everyFifteenDays:
            break
        case .startAndEnd:
            break
        case .daily:
            break
        case .satisfaction:
            break
        }
        
        return triggers
    }
    
    func maxNotificationAllowedBetween(_ date1: Date, and date2: Date, type: NotificationType) -> Int {
        var posibleNotification = 0
        let firstDate = date1
        var secondDate = date2
                
        if firstDate > secondDate { // 11pm > 8am true
            secondDate = secondDate.modifyDateFor(days: 1)
        }
    
        switch type {
        case .postureReminder:
            posibleNotification = abs(Int(DateInterval(start: firstDate, end: secondDate).duration / Constants.postureReminderOffset))
            print("Posible \(posibleNotification) notifications for posture reminder.")
            
        case .exercise:
            posibleNotification = abs(Int(DateInterval(start: firstDate, end: secondDate).duration / Constants.exerciseReminderOffset))
            print("Posible \(posibleNotification) notifications for exercise reminder.")
        case .restReminder:
            posibleNotification = abs(Int(DateInterval(start: firstDate, end: secondDate).duration / Constants.restReminderOffset))
            print("Posible \(posibleNotification) notifications for rest reminder.")
            
        case .oneTime:
            break
        case .everyFifteenDays:
            break
        case .startAndEnd:
            break
        case .daily:
            break
        case .satisfaction:
            break
        }
        
        return posibleNotification
    }
    
    func requestForAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("User allowed notifications")
                Task {
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    await self.generateNotifications()
                }
            } else if let error = error {
                print(error.localizedDescription)
            } else {
                print("User has notifications off!")
            }
        }
    }
    
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
    
     func devgenerateNotificationOfExercise() async {
        let center = UNUserNotificationCenter.current()
        
        let notificationTitle = getNotificationTitle(of: .exercise)
        let notificationSub = getNotificationDescription(of: .exercise)
        let exerciseForNotification = await Exercises().available.randomElement()!
        
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
            print("Image called: \(exerciseForNotification.icon)")
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
                print("Notification could not be added asking permissions")
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
//            guard let imageURL = Bundle.main.url(forResource: imageName, withExtension: "png") else {
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
