//
//  Achievement.swift
//  Posture Check
//
//  Created by Juancarlos Moldes on 9/28/22.
//
import SwiftUI

class Achievement: Codable, Equatable, Identifiable {
    
    var id = UUID()
    let name: String
    let description: String
    //var icon: String
    //Array of strings that will contain the path to the 15 medal icons
    var isAchieved: Bool
    var type: AchievementType
    
    enum AchievementType: Codable {
        case oneTime
    }
    
    init(id: UUID = UUID(), name: String, description: String, isAchieved: Bool, type: AchievementType) {
        self.name = name
        self.description = description
        self.isAchieved = isAchieved
        self.type = type
    }
    
    
    static func == (lhs: Achievement, rhs: Achievement) -> Bool {
        lhs.id == rhs.id
    }
    
    var objDescription: String {
        return """
        id: \(id)
        name: \(name)
        description: \(description)
        isAchieved: \(isAchieved)
        type: \(type)
        """
    }
    
    static var example: Achievement {
        Achievement(name: "The Posture Checker", description: "This achievement is not real and only for testing.", isAchieved: false, type: .oneTime)
    }
}

@MainActor class Achievements: ObservableObject {
    @Published private(set) var achievements: [Achievement]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent(Keys.achievements)
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            achievements = try JSONDecoder().decode([Achievement].self, from: data)
        } catch {
            achievements = Achievements.fillAchievements()
            save()
        }
    }
    
    static func fillAchievements() -> [Achievement] {
        return [
            Achievement(name: "Level 1", description: "Journey Starter", isAchieved: false, type: .oneTime),
            Achievement(name: "Level 2", description: "Beginner", isAchieved: false, type: .oneTime),
            Achievement(name: "Level 3", description: "Rookie", isAchieved: false, type: .oneTime),
            Achievement(name: "Level 4", description: "Patient", isAchieved: false, type: .oneTime),
            Achievement(name: "Level 5", description: "Intermediate", isAchieved: false, type: .oneTime),
            Achievement(name: "Level 6", description: "Persistent", isAchieved: false, type: .oneTime),
            Achievement(name: "Level 7", description: "Explorer", isAchieved: false, type: .oneTime),
            Achievement(name: "Level 8", description: "Dedicated", isAchieved: false, type: .oneTime),
            Achievement(name: "Level 9", description: "Fighter", isAchieved: false, type: .oneTime),
            Achievement(name: "Level 10", description: "Advanced", isAchieved: false, type: .oneTime),
            Achievement(name: "Level Bronze", description: "Grasshopper", isAchieved: false, type: .oneTime),
            Achievement(name: "Level Silver", description: "Expert", isAchieved: false, type: .oneTime),
            Achievement(name: "Level Sapphire", description: "Veteran", isAchieved: false, type: .oneTime),
            Achievement(name: "Level Diamond", description: "Master", isAchieved: false, type: .oneTime),
            Achievement(name: "Level Gold", description: "Legend", isAchieved: false, type: .oneTime)
        ]
    }
    
    func unlockAchievement(_ achievement: Achievement) {
        guard let index = achievements.firstIndex(of: achievement) else {
            fatalError("Couldn't find the achievement!")
        }
        
        objectWillChange.send()
        achievements[index].isAchieved = true
    }
    
    func save() {
        do {
            let encodedAchievements = try JSONEncoder().encode(achievements)
            try encodedAchievements.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            fatalError("Error saving achievements")
        }
    }
}
