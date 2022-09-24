//
//  Notifications.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 9/6/22.
//

import Foundation
import UserNotifications
import SwiftUI


class Notifications: ObservableObject {
    
    @Published var startTime      = Date() {
        didSet {
            UserDefaults.standard.set(startTime, forKey: Constants.UserDefaults.notificationStartTime)
        }
    } // notification start time
    @Published var endTime        = Date() {
        didSet {
            UserDefaults.standard.set(endTime, forKey: Constants.UserDefaults.notificationEndTime)
        }
    } // notification end time
    @Published var isTimeFrameSet = false  {
        didSet {
            UserDefaults.standard.set(isTimeFrameSet, forKey: Constants.UserDefaults.isNotificationTimeFrameSet)
        }
    } // to check if notifications start and end time are set
    
    init() {
        
        // load time from user defaults
        if let sTime = UserDefaults.standard.value(forKey: Constants.UserDefaults.notificationStartTime) as? Date { startTime = sTime }
        if let eTime = UserDefaults.standard.value(forKey: Constants.UserDefaults.notificationEndTime) as? Date { endTime = eTime }
        isTimeFrameSet = UserDefaults.standard.bool(forKey: Constants.UserDefaults.isNotificationTimeFrameSet)
        
    }
    
}


// MARK: - Getter Functions
// MARK: -
extension Notifications {
    
    func getTimeWith(incrementMinutes: Double) -> [[Int]] {
        
        let (startHour, startMinute, endHour, endMinute) = getHourAndMinutes()
        
        var timeArray: [[Int]] = []
        
        var currentTime: Double = Double(startHour) + Double(startMinute)/60
        let lastTime: Double = Double(endHour) + Double(endMinute)/60
        
        timeArray.append([startHour, startMinute])
        
        while (currentTime + (incrementMinutes/60)) <= lastTime {
            currentTime += (incrementMinutes/60)
            let hours = Int(floor(currentTime))
            let minutes = Int(currentTime.truncatingRemainder(dividingBy: 1)*60)
            if minutes == 0 {
                timeArray.append([hours,0])
            } else {
                timeArray.append([hours,minutes])
            }
        }
        
        print("\n\n\n**** Interval: \(incrementMinutes) min")
        print("**** startTime: \(startHour):\(startMinute)")
        print("**** endTime: \(endHour):\(endMinute)")
        print("**** times: \(timeArray)")
        
        return timeArray
        
    }
    
    func getHourAndMinutes() -> (Int,Int,Int,Int) {
        
        let calendar = Calendar.current
        
        let startHour = calendar.component(.hour, from: startTime)
        let startMinute = calendar.component(.minute, from: startTime)
        let endHour = calendar.component(.hour, from: endTime)
        let endMinute = calendar.component(.minute, from: endTime)
        
        return (startHour, startMinute, endHour, endMinute)
        
    }
    
}


// MARK: - Setter Functions
// MARK: -
extension Notifications {
    
}


// MARK: - Helper Functions
// MARK: -
extension Notifications {
    
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
    
    func isValidateTimeFrame() -> Bool {
        
        let (startHour, startMinute, endHour, endMinute) = getHourAndMinutes()
        
        if startHour < endHour || (startHour == endHour && startMinute < endMinute) {
            return true
        }
        
        return false
        
    }

}



enum NotificationType {
    case twentyMinutes, getUp, move // TODO: Review this against client requirements Hint: WhatsApp - Luis
}


var randomMessages = ["RandomMessage 1", "RandomMessage 2", "RandomMessage 3", "RandomMessage 4", "RandomMessage 5", "RandomMessage 6", "RandomMessage 7", "RandomMessage 8", "RandomMessage 9", "RandomMessage 10", ] // TODO: - random messages, to be replaced by the client later
