//
//  Questionnaires.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 9/2/22.
//

import SwiftUI

class Questionnaire: Codable, Identifiable, Equatable {
    var id = UUID()
    let name: String
    let url: URL
    var isCompleted: Bool
    var isAvailable: Bool
    let type: FormType
    
    init(name: String, url: URL, isCompleted: Bool = false, isAvailable: Bool = false, type: FormType) {
        self.name = name
        self.url = url
        self.isCompleted = isCompleted
        self.isAvailable = isAvailable
        self.type = type
    }
    
    enum FormType: Codable {
        case oneTime, everyFifteenDays, startAndEnd, daily, satisfaction
    }
    
    static func == (lhs: Questionnaire, rhs: Questionnaire) -> Bool {
        lhs.id == rhs.id
    }
    
    static var example: Questionnaire {
        Questionnaire(name: "Test Questionnaire", url: URL(string: "https://www.apple.com")!, type: .oneTime)
    }
}


@MainActor class Questionnaires: ObservableObject {
    @Published private(set) var questionnaires: [Questionnaire]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent(Keys.questionnaires)
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            questionnaires = try JSONDecoder().decode([Questionnaire].self, from: data)
        } catch {
            questionnaires = Questionnaires.fillQuestionnaires()
            // Add save below
        }
    }
    
    // TODO: Add some kind of classifier since some polls are daily and some are biweekly.
    /// This function will populate the app questionnaires when is needed.
    /// - Returns: An array of questionnaires
    static func fillQuestionnaires() -> [Questionnaire] {
        return [
            Questionnaire(name: "Sociodemographic", url: URL(string: "https://www.apple.com")!, isAvailable: true, type: .oneTime),
            Questionnaire(name: "Auto Perception of Posture", url: URL(string: "https://www.apple.com")!, type: .startAndEnd),
            Questionnaire(name: "Numeric Pain Rating Scale", url: URL(string: "https://www.apple.com")!, type: .everyFifteenDays),
            Questionnaire(name: "Daily Exercise Report", url: URL(string: "https://www.apple.com")!, type: .daily),
            Questionnaire(name: "Satisfaction", url: URL(string: "https://www.apple.com")!, type: .oneTime)
        ]
    }
    
    func markAsCompleted(_ questionnaire: Questionnaire) {
        guard let index = questionnaires.firstIndex(of: questionnaire) else {
            fatalError("Couldn't find the questionnaire!")
        }
        
        objectWillChange.send()
        questionnaires[index].isAvailable = false
        questionnaires[index].isCompleted = true
    }
}
