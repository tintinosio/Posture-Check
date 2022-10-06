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
    

    
    init(id: UUID = UUID(), name: String, description: String, isAchieved: Bool) {
        self.name = name
        self.description = description
        self.isAchieved = isAchieved
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
        """
    }
    
    static var example: Achievement {
        Achievement(name: "The Posture Checker", description: "This achievement is not real and only for testing.", isAchieved: false)
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
            Achievement(name: "Level 1", description: "Journey Starter", isAchieved: false),
            Achievement(name: "Level 2", description: "Beginner", isAchieved: false),
            Achievement(name: "Level 3", description: "Rookie", isAchieved: false),
            Achievement(name: "Level 4", description: "Patient", isAchieved: false),
            Achievement(name: "Level 5", description: "Intermediate", isAchieved: false),
            Achievement(name: "Level 6", description: "Persistent", isAchieved: false),
            Achievement(name: "Level 7", description: "Explorer", isAchieved: false),
            Achievement(name: "Level 8", description: "Dedicated", isAchieved: false),
            Achievement(name: "Level 9", description: "Fighter", isAchieved: false),
            Achievement(name: "Level 10", description: "Advanced", isAchieved: false),
            Achievement(name: "Level Bronze", description: "Grasshopper", isAchieved: false),
            Achievement(name: "Level Silver", description: "Expert", isAchieved: false),
            Achievement(name: "Level Sapphire", description: "Veteran", isAchieved: false),
            Achievement(name: "Level Diamond", description: "Master", isAchieved: false),
            Achievement(name: "Level Gold", description: "Legend", isAchieved: false)
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
