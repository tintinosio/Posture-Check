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
    @State var selection = 1
    @StateObject var questionnaires = Questionnaires()
    @StateObject var exercises = Exercises()
    @StateObject var notifications = Notifications()
    @StateObject var appSettings = AppSettings()
    
    var body: some View {
        TabView(selection: $selection) {
            ExerciseListView()
                .tabItem {
                    Label("Exercises", systemImage: "person.and.arrow.left.and.arrow.right")
                }
                .tag(0)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(1)
            
            ConditionalQuestionnaireView()
                .tabItem {
                    Label("Questionares", systemImage: "questionmark.circle.fill")
                }
                .tag(2)
            
            if (TARGET_OS_SIMULATOR != 0) {
                DeveloperView(accentColor: appSettings.appAccent)
                    .tabItem {
                        Label("Developer Mode", systemImage: "hammer.circle")
                    }
                    .tag(3)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
