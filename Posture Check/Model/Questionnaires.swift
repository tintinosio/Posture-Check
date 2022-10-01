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
    let dateExpectedToBeCompleted: Date
    
    enum FormType: Codable, CaseIterable {
        
        case oneTime // Sociodemografico 1
        case everyFifteenDays // Numeric Pain Rating hasta el 45
        case startAndMonthly // Autopercepcion dos 1 y el 30
        case daily // Auto report exercise
        case satisfaction // Al dia 30
    }
    
    init(id: UUID = UUID(), name: String, url: URL, isCompleted: Bool = false, isAvailable: Bool = false, type: FormType, dateExpectedToBeCompleted: Date) {
        self.id = id
        self.name = name
        self.url = url
        self.isCompleted = isCompleted
        self.isAvailable = isAvailable
        self.type = type
        self.dateExpectedToBeCompleted = dateExpectedToBeCompleted
    }
    
    static func == (lhs: Questionnaire, rhs: Questionnaire) -> Bool {
        lhs.id == rhs.id
    }
    
    static var example: Questionnaire {
        Questionnaire(name: "Test Questionnaire", url: URL(string: "https://www.apple.com")!, type: FormType.oneTime, dateExpectedToBeCompleted: Date.now)
    }
}


@MainActor class Questionnaires: ObservableObject {
    @Published private(set) var questionnaires: [Questionnaire]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent(Keys.questionnaires)
    
    var isAnyQuestionnaireAvailable: Bool {
        var isQuestionnaireAvailable = false
        
        for questionnaire in questionnaires {
            if questionnaire.isAvailable {
                isQuestionnaireAvailable = true
                return isQuestionnaireAvailable
            }
        }
        
        return isQuestionnaireAvailable
    }
    
    var questionnairesAvailableCount: Int {
        var count = 0
        
        for questionnaire in questionnaires {
            if questionnaire.isAvailable {
                count += 1
            }
        }
        return count
    }
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            questionnaires = try JSONDecoder().decode([Questionnaire].self, from: data)
        } catch {
            questionnaires = Questionnaires.fillQuestionnaires()
//            save()
        }
    }
    
    // TODO: Add some kind of classifier since some polls are daily and some are biweekly.
    /// This function will populate the app questionnaires when is needed.
    /// - Returns: An array of questionnaires
    static func fillQuestionnaires() -> [Questionnaire] {
        return [
            Questionnaire(name: "Sociodemographic", url: URL(string: "https://www.apple.com")!, isAvailable: true, type: .oneTime, dateExpectedToBeCompleted: Date.now),
            Questionnaire(name: "Auto Perception of Posture", url: URL(string: "https://www.apple.com")!, type: .startAndMonthly, dateExpectedToBeCompleted: Date.now),
            Questionnaire(name: "Auto Perception of Posture", url: URL(string: "https://www.apple.com")!, type: .startAndMonthly, dateExpectedToBeCompleted: Date.now.modifyDateFor(days: 29)),
            Questionnaire(name: "Numeric Pain Rating Scale", url: URL(string: "https://www.apple.com")!, type: .everyFifteenDays, dateExpectedToBeCompleted: Date.now),
            Questionnaire(name: "Daily Exercise Report", url: URL(string: "https://www.apple.com")!, type: .daily, dateExpectedToBeCompleted: Date.now),
            Questionnaire(name: "Satisfaction", url: URL(string: "https://www.apple.com")!, type: .oneTime, dateExpectedToBeCompleted: Date.now)
        ]
    }
    
//    func fillQuestionnaireOf(_ type: Questionnaire.FormType) {
//        var questionnaires = [Questionnaires]()
//        switch type {
//        case .oneTime:
//            Questionnaire(name: "Sociodemographic", url: URL(string: "https://www.apple.com")!, type: .oneTime, dateExpectedToBeCompleted: Date.now)
//
//        case .everyFifteenDays:
//            for index in 0..<46 {
//                Questionnaire(name: "Numeric Pain Rating Scale", url: URL(string: "https://www.apple.com")!, type: .everyFifteenDays, dateExpectedToBeCompleted: Date.now.modifyDateFor(days: index))
//            }
//
//        case .startAndMonthly:
//            break
//        case .daily:
//            break
//        case .satisfaction:
//            break
//        }
//    }
    
    func markAsCompleted(_ questionnaire: Questionnaire) {
        guard let index = questionnaires.firstIndex(of: questionnaire) else {
            fatalError("Couldn't find the questionnaire!")
        }
        
        objectWillChange.send()
        questionnaires[index].isAvailable = false
        questionnaires[index].isCompleted = true
//        save()
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
