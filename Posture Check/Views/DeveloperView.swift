//
//  DeveloperView.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 8/31/22.
// // MARK: Solo para uso interno!

import SwiftUI

struct DeveloperView: View {
    @EnvironmentObject var appSettings: AppSettings
    @State var accentColor: Color
    @EnvironmentObject var notification: Notifications
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Place below controls to alter user progress for testing purposes.")
                    .font(.largeTitle.bold())
                
                Form {
                    ColorPicker("App Accent:", selection: $accentColor, supportsOpacity: false)
                    
                    Section("Notifications") {
                        Button("Posture Reminder") {
                            Task {
                                 notification.devgenerateNotificationsOf(type: .postureReminder)
                            }
                        }
                        Button("Exercise Reminder") {
                            Task {
                                await notification.devgenerateNotificationOfExercise()
                            }
                        }
                        Button("Downtime Reminder") {
                            Task {
                                notification.devgenerateNotificationsOf(type: .restReminder)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Developer Mode")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: accentColor) { newValue in
            appSettings.appAccent = newValue
        }
        .onAppear {
            notification.requestForAuthorization()
            let test1 = Calendar.current.date(from: appSettings.activeFrom)
            let test2 = Calendar.current.date(from: appSettings.activeUpTo)
            print("Active from: \(appSettings.activeFrom) Formatted: \(test1?.formatted())\n Active up to: \(appSettings.activeUpTo) Formatted: \(test2?.formatted())")
        }
    }
}

struct DeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperView(accentColor: .indigo)
            .environmentObject(AppSettings())
    }
}

