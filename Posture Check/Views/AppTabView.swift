//
//  AppTabView.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 10/1/22.
//

import SwiftUI

struct AppTabView: View {
    @State var selection = 0

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
                DeveloperView(accentColor: AppSettings().appAccent)
                    .tabItem {
                        Label("Developer Mode", systemImage: "hammer.circle")
                    }
                    .tag(3)
            }
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
