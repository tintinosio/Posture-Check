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
//    let dateExpectedToBeCompleted: Date
    
    enum FormType: Codable {
        case oneTime, everyFifteenDays, startAndEnd, daily, satisfaction
    }
    
    init(id: UUID = UUID(), name: String, url: URL, isCompleted: Bool = false, isAvailable: Bool = true, type: FormType) {
        self.id = id
        self.name = name
        self.url = url
        self.isCompleted = isCompleted
        self.isAvailable = isAvailable
        self.type = type
    }
    
    static func == (lhs: Questionnaire, rhs: Questionnaire) -> Bool {
        lhs.id == rhs.id
    }
    
    static var example: Questionnaire {
        Questionnaire(name: "Test Questionnaire", url: URL(string: "https://www.apple.com")!, type: FormType.oneTime)
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
            save()
        }
    }
    
    // TODO: Add some kind of classifier since some polls are daily and some are biweekly.
    /// This function will populate the app questionnaires when is needed.
    /// - Returns: An array of questionnaires
    static func fillQuestionnaires() -> [Questionnaire] {
        return [
            Questionnaire(name: "Sociodemographic", url: URL(string: "https://www.apple.com")!, type: .oneTime),
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
        save()
    }
    
    func isAnyQuestionnaireAvailable() -> Bool {
        var isQuestionnaireAvailable = false
        
        for questionnaire in questionnaires {
            if questionnaire.isAvailable {
                isQuestionnaireAvailable = true
                return isQuestionnaireAvailable
            }
        }
        
        return isQuestionnaireAvailable
    }
    
    func save() {
        do {
            let encodedQuestionnaires = try JSONEncoder().encode(questionnaires)
            try encodedQuestionnaires.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
        } catch {
            fatalError("Error saving questionnaires")
        }
    }
}
