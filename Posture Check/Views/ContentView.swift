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

struct ContentView: View {
    @StateObject var questionnaires = Questionnaires()
    @StateObject var exercises = Exercises()
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
        .environmentObject(exercises)
        .environmentObject(questionnaires)
        .environmentObject(notifications)
        .environmentObject(appSettings)
        .accentColor(appSettings.appAccent)
        .onAppear { // NOTE: This code should be asked on a earlier view of the app and not here.
//            notifications.requestForAuthorization()
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                notifications.generateNotifications()
//            }
            
        }
    }
}

struct NotificationRoadBlockView: View {
    @EnvironmentObject var notifications: Notifications
    
    var body: some View {
        VStack {
            Image(systemName: "bell")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .foregroundColor(.red)
                .padding(.top)
            
            Text("This app requires the use of notifications to work. Please allow the use of notifications.")
                .font(.title)
            Spacer()
            
            Button("Allow") {
                notifications.requestForAuthorization()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
