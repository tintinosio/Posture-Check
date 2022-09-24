//
//  ExerciseListView.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 8/29/22.
//

// MARK: File Description
/*
 This view will be responsible for hosting all unlocked and non unlocked exercises it will be also the view responsible to segue to ExerciseDetailView. The list will be initialized via an environment object.
 */

import SwiftUI

struct ExerciseListView: View {
    
    @Environment(\.colorScheme) var colorScheme // for checking if app is in dark or light mode

    @EnvironmentObject var exercises    : Exercises
    @EnvironmentObject var notifications: Notifications
    
    @State private var showAsGrid                 = true
    @State private var isOnAppearCalled           = false // for calling onAppear only once
    @State private var showNotificationTimerView  = false // show/hide notification time view
    @State private var showNotificationErrorAlert = false // show/hide notification error
    
    var body: some View {
        NavigationView {
            List {
                ForEach(exercises.exercises, id: \.id) { exercise in
                    NavigationLink {
                        ExerciseDetailView(exercise: exercise)
                    } label: {
                        Text(exercise.name)
                    }
                }
            }
            .navigationTitle("Exercise")
            .toolbar {
                Button() {
                    showAsGrid.toggle()
                } label: {
                    Text(showAsGrid ? "Show as List" : "Show as Grid")
                }
            }
            .onAppear{ onAppearHandling() }
            .overlay { TimerView() }
            .toolbar { TopLeftButton() }
        }
    }
    
}

// MARK: - View Functions
// MARK: -
extension ExerciseListView {
    
    func TimerView() -> some View {
        
        ZStack {
            
            VStack {
                
                //-------------------------------------------------- Title
                
                Text("Set time")
                    .font(.title)
                    .bold()
                
                
                //-------------------------------------------------- Start Time
                
                HStack {
                    Text("Start time")
                    DatePicker("", selection: $notifications.startTime, displayedComponents: .hourAndMinute)
                }
                
                
                //-------------------------------------------------- End Time
                
                HStack {
                    Text("End time")
                    DatePicker("", selection: $notifications.endTime, displayedComponents: .hourAndMinute)
                }
                
                
                //-------------------------------------------------- Done
                
                Button {
                    timerFrameDoneButtonAction()
                } label: {
                    Text("Done")
                        .bold()
                }
                .buttonStyle(.bordered)
                .alert(isPresented: $showNotificationErrorAlert, content: {  Alert(title: Text("Error"), message: Text("Start time can not be after the end time"))
                })
                
            }
            .padding()
            
        }
        .frame(width: UIScreen.main.bounds.width * 0.8, height: 220)
        .background(colorScheme == .dark ? Color(hex: "212121") : .white)
        .cornerRadius(20)
        .opacity(showNotificationTimerView ? 1 : 0)
        .frame(maxWidth: .greatestFiniteMagnitude, maxHeight: .greatestFiniteMagnitude)
        .background(Color.black.opacity(0.7).opacity(showNotificationTimerView ? 1 : 0))
        .animation(.default, value: showNotificationTimerView)
        
    }
    
    func TopLeftButton() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showNotificationTimerView.toggle()
            } label: {
                Text("Set Notification Time")
            }

        }
    }
    
}


// MARK: - Helper Functions
// MARK: -
extension ExerciseListView {
    
    func onAppearHandling() {
        
        // for calling onAppear only once
        guard isOnAppearCalled == false else { return }
        isOnAppearCalled = true
        
        getNotificationsPermission()
        
    }
    
    func getNotificationsPermission() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            guard success else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // check if notification timer is set
                guard notifications.isTimeFrameSet == false else { return }
                showNotificationTimerView = true
            }
        }
    }
    
    func timerFrameDoneButtonAction() {
        
        // check if start time is lower than end time
        guard notifications.isValidateTimeFrame() else {
            showNotificationErrorAlert = true; return
        }
        
        // hide timer view
        showNotificationTimerView.toggle()
        notifications.isTimeFrameSet = true
        
        // set all 3 notifications
        setNotifications()
        
    }
        
}

// MARK: - Notification Functions
// MARK: -
extension ExerciseListView {
    
    func setNotifications() {
        
        // for cancelling all notification
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        // timers
        let timers1 = notifications.getTimeWith(incrementMinutes: 21)
        let timers2 = notifications.getTimeWith(incrementMinutes: 60)
        let timers3 = notifications.getTimeWith(incrementMinutes: 180)
        
        // triggers
        let triggers1 = setNotificationTriggers(timers: timers1, sec: 0)
        let triggers2 = setNotificationTriggers(timers: timers2, sec: 10)
        let triggers3 = setNotificationTriggers(timers: timers3, sec: 20)
        
        // notifications
        notification1(triggers: triggers1)
        notification2(triggers: triggers2)
        notification3(triggers: triggers3)
        
    }
    
    func notification1(triggers: [UNCalendarNotificationTrigger]) {
        
        for trigger in triggers {
            
            // create the content of the notification
            let content   = UNMutableNotificationContent()
            content.title = "Notification Type 1"
            content.body  = randomMessages.randomElement() ?? ""
            content.sound = .default
            
            setNotificationRequest(content: content, trigger: trigger)
            
        }
        
    }
    
    func notification2(triggers: [UNCalendarNotificationTrigger]) {
        
        for trigger in triggers {

            // create the content of the notification
            let content   = UNMutableNotificationContent()
            content.title = "Notification Type 2"
            content.body  = exercises.exercises.randomElement()?.name ?? ""
            content.sound = .default

            setNotificationRequest(content: content, trigger: trigger)

        }
        
    }
    
    func notification3(triggers: [UNCalendarNotificationTrigger]) {
        
        for trigger in triggers {

            // create the content of the notification
            let content   = UNMutableNotificationContent()
            content.title = "Notification Type 3"
            content.body  = "Take a break"
            content.sound = .default
            
            setNotificationRequest(content: content, trigger: trigger)

        }
        
    }
    
    func setNotificationTriggers(timers: [[Int]], sec: Int) -> [UNCalendarNotificationTrigger] {
        
        var triggers: [UNCalendarNotificationTrigger] = []
        
        for timer in timers {
            let trigger = UNCalendarNotificationTrigger(dateMatching: .triggerFor(hour: timer.first!, minute: timer.last!, sec: sec), repeats: true)
            triggers.append(trigger)
        }
        
        return triggers
        
    }
    
    func setNotificationRequest(content: UNMutableNotificationContent, trigger: UNCalendarNotificationTrigger) {
        
        // create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // schedule requests
        UNUserNotificationCenter.current().add(request) { (error) in
            if let theError = error { print("**** type3 notification error: \(theError.localizedDescription)") }
        }
        
    }
}


// MARK: - Preview
// MARK: -
struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
            ExerciseListView()
            .environmentObject(Exercises())
    }
}
