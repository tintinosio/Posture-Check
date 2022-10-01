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
                                }
                                
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
                                LazyVGrid(columns: columns) {
                                    ForEach(1..<10, id: \.self) { _ in
                                        VStack {
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(width: 100, height: 125)
                                                .foregroundColor(.indigo)
                                            Text("Title")
                                                .font(.callout)
                                        }
                                    }
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
