//
//  AppDelegate.swift
//  Posture Check
//
//  Created by Hector Rodriguez on 9/24/22.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
}


// MARK: - Notification Delegate Functions
// MARK: -
extension AppDelegate: UNUserNotificationCenterDelegate  {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // get exercise name
        let name = response.notification.request.content.body
        let exercises = Exercises()
        
        // fetch exercise from list
        if let exercise = exercises.exercises.first(where: { $0.name == name }) {
            
            // display exercise view
            let vc = UIHostingController(rootView: ExerciseDetailView(exercise: exercise))
            let mainVC = UIApplication.shared.keyWindowCustom?.rootViewController
            mainVC?.present(vc, animated: true)
            
        }
        
        completionHandler()
    }
        
}
