//
//  ContentView.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 8/27/22.
//

// MARK: File Description
/*
 Host all views of app Posture Check enclosed in a TabView.
 Each ObservedObject will be pass as environment object to avoid repetition an object passing in views initializers.
 */

import SwiftUI
import BackgroundTasks

struct ContentView: View {
    @StateObject var user = User()
    @StateObject var notifications = Notifications()
    @StateObject var appSettings = AppSettings()
    
    var body: some View {
        
        Group {
            if !notifications.userHasGrantedPermissions { // MARK: Fix me - Logic not working
                AppTabView()
            } else {
                NotificationRoadBlockView()
            }
        }
        .environmentObject(user)
        .environmentObject(notifications)
        .environmentObject(appSettings)
        .accentColor(appSettings.appAccent)
        .onAppear { // NOTE: This code should be asked on a earlier view of the app and not here.
            notifications.requestForAuthorization()
            
            Task {
                await print(UNUserNotificationCenter.current().pendingNotificationRequests())
        }
            user.questionnaires.unlockQuestionnairesPending()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
