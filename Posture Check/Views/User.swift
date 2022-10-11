//
//  User.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 10/8/22.
//
import SwiftUI

@MainActor class User: ObservableObject {
    @Published var exercises: Exercises
    @Published var questionnaires: Questionnaires
    @Published var achievements: Achievements

    init() {
        exercises = Exercises()
        questionnaires = Questionnaires()
        achievements = Achievements()
    }
}
