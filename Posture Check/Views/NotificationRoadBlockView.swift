//
//  NotificationRoadBlockView.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 10/2/22.
//

import SwiftUI

struct NotificationRoadBlockView: View {
    @EnvironmentObject var notifications: Notifications // Not use Notifications and use UserDefaults maybe
    
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

struct NotificationRoadBlockView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationRoadBlockView()
    }
}
