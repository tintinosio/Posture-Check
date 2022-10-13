//
//  SettingsView.swift
//  Posture Check
//
//  Created by Gamalier Rodriguez Delgado.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appSettings: AppSettings
    @State var from: Date
    @State var UpTo: Date
    
    init() {
        let appSettings = AppSettings()
        _from = State(initialValue: Calendar.autoupdatingCurrent.date(from: appSettings.activeFrom) ?? Date.now)
        _UpTo = State(initialValue: Calendar.autoupdatingCurrent.date(from: appSettings.activeUpTo) ?? Date.now)
    }
    //MARK: Fix/Add saving to UserDefaults and remove previous notifications and create new ones.
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker(selection: $from, displayedComponents: .hourAndMinute, label: { SettingsRowView( title: "Start Stretching", systemImageName: "bell")
                    })
                }
            header: {
                Text("Notifications")
                    .font(.subheadline)
            }
                
                Section {
//                    Stepper("\(stretchingTime.formatted()) hours", value: $stretchingTime, in: 6...9, step: 1.00)
                    DatePicker("End", selection: $UpTo, displayedComponents: .hourAndMinute)
                }
            header: {
                Text("Stretching time select:")
                    .font(.subheadline)
            }
            }
            .navigationTitle(Text("Settings"))
        }
        .onChange(of: from) { newValue in
            let dateComponents = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute], from: from)
            print(dateComponents)
            print("Cambie from")
        }
        .onChange(of: UpTo) { newValue in
            let dateComponents = Calendar.autoupdatingCurrent.dateComponents([.hour, .minute], from: from)
            print(dateComponents)
            print("Cambie upto")
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
            .environmentObject(AppSettings())
    }
}
