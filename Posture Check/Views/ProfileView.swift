//
//  ProfileView.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 8/29/22.
//

// MARK: File Description
/*
 This view will be responsible for displaying user profiles details like day in study, level and achievements.
 */

import SwiftUI

struct ProfileView: View {
    @State private var showingButton = false
    
    var body: some View {
        NavigationView {
            Text("Profile")
                .navigationTitle("Profile")
                .toolbar {
                    Button {
                        showingButton = true
                    } label: {
                        Image (systemName: "gear")
                    }
                }
                .sheet(isPresented: $showingButton) {
                    SettingsView()
                }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
