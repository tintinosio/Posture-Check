//
//  AppSettings.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 9/22/22.
//

import Combine
import Foundation
import SwiftUI

@MainActor class AppSettings: ObservableObject {
    @Published var isNewUser: Bool {
        didSet {
            UserDefaults.standard.set(isNewUser, forKey: Keys.isNewUser)
        }
    }
    
    @Published var dateInstalled: Date {
        didSet {
            UserDefaults.standard.set(dateInstalled, forKey: Keys.dateInstalled)
        }
    }
    
    @Published var appAccent: Color {
        didSet {
            UserDefaults.standard.set(appAccent, forKey: Keys.appAccent)
        }
    }
    
    // TODO: Consider 24 hour format
    @Published var activeFrom: Date {
        didSet {
            UserDefaults.standard.set(activeFrom, forKey: Keys.activeFrom)
        }
    }
    
    @Published var activeUpTo: Date {
        didSet {
            UserDefaults.standard.set(activeUpTo, forKey: Keys.activeUpTo)
        }
    }
    
    init() {
        // guard let isNewUser = UserDefaults.standard.object(forKey: Keys.isNewUser),
        //              let dataInstalled = UserDefaults.standard.object(forKey: Keys.dateInstalled),
        //              let appAccent = UserDefaults.standard.object(forKey: Keys.appAccent),
        //              let activeFrom = UserDefaults.standard.object(forKey: Keys.activeFrom),
        //              let activeUpTo = UserDefaults.standard.object(forKey: Keys.activeUpTo) else {
        //
        //            self.setDefaultsValues()
        //            return
        //        }
        //
        //        if let decodedIsNewUser = try? decoder.decode(Bool.self, from: isNewUser) {
        //            _isNewUser = State(initialValue: decodedIsNewUser)
        //        }
        self.isNewUser = UserDefaults.standard.object(forKey: Keys.isNewUser) as? Bool ?? true
        self.dateInstalled = UserDefaults.standard.object(forKey: Keys.dateInstalled) as? Date ?? Date.now
        self.appAccent = UserDefaults.standard.object(forKey: Keys.appAccent) as? Color ?? .indigo
        self.activeFrom = UserDefaults.standard.object(forKey: Keys.activeFrom) as? Date ?? Date.now
        self.activeUpTo = UserDefaults.standard.object(forKey: Keys.activeUpTo) as? Date ?? Date.now.addingTimeInterval(8.0 * 3600)
        
        print("User Defaults Ready")
    }
}
