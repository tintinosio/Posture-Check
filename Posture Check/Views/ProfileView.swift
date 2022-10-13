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
    @EnvironmentObject var user: User
    @State private var isShowingSettings = false
    @State private var isShowingPostureCheckUI = false
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal)
                                .frame(width: 100, height: 100)
                                .offset(y: 5)
                                .onTapGesture {
                                    Task {
                                       await print(UNUserNotificationCenter.current().pendingNotificationRequests())
                                    }
                                }
                            
                            VStack {
                                HStack {
                                    Text("Summary")
                                        .font(.callout)
                                        .bold()
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                    Text("Level \(2)")
                                    Spacer()
                                }
                                
                                if #available(iOS 16.0, *) {
                                    Gauge(value: 0.1) {
                                        HStack {
                                            Text("Study Progress")
                                            Spacer()
                                        }
                                    }
                                    .padding(.top)
                                    .accentColor(.indigo)
                                    
                                } else {
                                    // Fallback on earlier versions
                                    ProgressBar(value: .constant(0.5))
                                    .frame(maxHeight: 15)                                }
                                
                                Divider()
                                    .frame(height: 15)
                            }
                        }
                        .frame(height: geometry.size.height * 0.25)
                        .padding(.horizontal)
                        
                        VStack {
                            HStack {
                                Text("Achievements")
                                    .font(.title)
                                Spacer()
                            }
                            
                            ScrollView(showsIndicators: false) {
                                ForEach(user.achievements.achievements, id: \.id) { achievement in
                                    AchievementView(achievement: achievement)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                Button {
                    isShowingSettings = true
                } label: {
                    Image (systemName: "gear")
                }
            }
            .sheet(isPresented: $isShowingSettings) {
                SettingsView()
            }
        }
    }
}

struct AchievementView: View {
    var achievement: Achievement
    
    var body: some View {
        VStack {
            Text(achievement.description)
            HStack {
                Group {
                    if !achievement.isAchieved {
                        
                        Image("Chin tuck icon")
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay {
                                Circle().stroke(
                                    Color.indigo,
                                    lineWidth: 5
                                )
                            }
                            .frame(width: 200)
                        
                        Spacer()
                        
                        Text(achievement.description)
                    }
                    
                }
                Spacer()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(User())
    }
}
