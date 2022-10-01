//
//  SettingsView.swift
//  Posture Check
//
//  Created by Gamalier Rodriguez Delgado.
//

import SwiftUI

struct SettingsView: View {
    
    @State var time = Date()
    @State private var stretchingTime = 8.0
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker(selection: $time, displayedComponents: .hourAndMinute, label: { SettingsRowView( title: "Start Stretching", systemImageName: "bell")
                    })
                }
            header: {
                Text("Notifications")
                    .font(.subheadline)
            }
                
                Section {
                    Stepper("\(stretchingTime.formatted()) hours", value: $stretchingTime, in: 6...9, step: 1.00)
                }
            header: {
                Text("Stretching time select:")
                    .font(.subheadline)
            }
            }
            .navigationTitle(Text("Settings"))
        }
    }
}

struct SettingsRowView: View {
    var title: String
    var systemImageName: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImageName)
            Text (title)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
