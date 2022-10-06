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
    var dateExpectedToBeCompleted: Date
    var timesUnlockedPreviously: Int
    
    enum FormType: Codable, CaseIterable {
        case oneTime // Sociodemografico 1
        case everyFifteenDays // Numeric Pain Rating hasta el 45
        case startAndMonthly // Autopercepcion dos 1 y el 30
        case daily // Auto report exercise
        case satisfaction // Al dia 30
    }
    
    init(id: UUID = UUID(), name: String, url: URL, isCompleted: Bool = false, isAvailable: Bool = false, type: FormType, dateExpectedToBeCompleted: Date, timesUnlockedPreviously: Int = 0) {
        self.id = id
        self.name = name
        self.url = url
        self.isCompleted = isCompleted
        self.isAvailable = isAvailable
        self.type = type
        self.dateExpectedToBeCompleted = dateExpectedToBeCompleted
        self.timesUnlockedPreviously = timesUnlockedPreviously
    }
    
    var description: String {
        return """
        id: \(id)
        name: \(name)
        url: \(url.formatted())
        isCompleted: \(isCompleted)
        isAvailable: \(isAvailable)
        type: \(type)
        dateExpectedToBeCompleted: \(dateExpectedToBeCompleted.formatted())
        timesUnlockedPreviously: \(timesUnlockedPreviously)
        """
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
            save()
        }
    }
    
    /// This function will populate the app questionnaires when is needed.
    /// - Returns: An array of questionnaires
    static func fillQuestionnaires() -> [Questionnaire] {
        return  [
            Questionnaire(name: "Sociodemographic", url: URL(string: "https://www.apple.com")!, isAvailable: true, type: .oneTime, dateExpectedToBeCompleted: Date.now),
            Questionnaire(name: "Numeric Pain Rating Scale", url: URL(string: "https://www.apple.com")!, isAvailable: true, type: .everyFifteenDays, dateExpectedToBeCompleted: Date.now),
            Questionnaire(name: "Auto Perception of Posture", url: URL(string: "https://www.apple.com")!, isAvailable: true ,type: .startAndMonthly, dateExpectedToBeCompleted: Date.now),
            Questionnaire(name: "Daily Exercise Report", url: URL(string: "https://www.apple.com")!, isAvailable: true ,type: .daily, dateExpectedToBeCompleted: Date.now),
            Questionnaire(name: "Satisfaction", url: URL(string: "https://www.apple.com")!, type: .oneTime, dateExpectedToBeCompleted: Date.now.modifyDateFor(days: 29))
            ]
        }
    
    func maxUnlockAllowedFor(_ type: Questionnaire.FormType) -> Int {
        var maxUnlockAllowed: Int

        switch type {
        case .oneTime:
            maxUnlockAllowed = 1
        case .everyFifteenDays:
            maxUnlockAllowed = 4
        case .startAndMonthly:
            maxUnlockAllowed = 2
        case .daily:
            maxUnlockAllowed = 44
        case .satisfaction:
            maxUnlockAllowed = 1
        }
        return maxUnlockAllowed
    }
    
    
    func unlockQuestionnairesPending() {
        let currentDate = Date.now.dateWithoutHours()
        
        for questionnaire in questionnaires {
            if questionnaire.dateExpectedToBeCompleted.dateWithoutHours() < currentDate || questionnaire.dateExpectedToBeCompleted.dateWithoutHours() == currentDate {
                if questionnaire.timesUnlockedPreviously < maxUnlockAllowedFor(questionnaire.type) {
                    if !questionnaire.isAvailable {
                        unlockQuestionnaire(questionnaire)
                    }
                }
            }
        }
    }
    
    func markAsCompleted(_ questionnaire: Questionnaire) {
        guard let index = questionnaires.firstIndex(of: questionnaire) else {
            fatalError("Couldn't find the questionnaire!")
        }
        
        print("Pre-Modified questionnaire: \(questionnaires[index].description)")
        
        objectWillChange.send()
        
        if questionnaire.timesUnlockedPreviously != maxUnlockAllowedFor(questionnaire.type) {
            switch questionnaire.type {
            case .oneTime:
                questionnaires[index].timesUnlockedPreviously += 1
                
            case .everyFifteenDays:
                questionnaires[index].timesUnlockedPreviously += 1
                questionnaires[index].dateExpectedToBeCompleted = Date.now.modifyDateFor(days: 15)
                
            case .startAndMonthly:
                questionnaires[index].timesUnlockedPreviously += 1
                questionnaires[index].dateExpectedToBeCompleted = Date.now.modifyDateFor(days: 29)
                
            case .daily:
                questionnaires[index].timesUnlockedPreviously += 1
                questionnaires[index].dateExpectedToBeCompleted = Date.now.modifyDateFor(days: 1)
                
            case .satisfaction:
                questionnaires[index].timesUnlockedPreviously += 1
            }
        }
        
        questionnaires[index].isAvailable = false
        questionnaires[index].isCompleted = true
        
        print("Modified questionnaire: \(questionnaires[index].description)")
        save()
    }
    
    func unlockQuestionnaire(_ questionnaire: Questionnaire) {
        guard let index = questionnaires.firstIndex(of: questionnaire) else {
            fatalError("Couldn't find the questionnaire!")
        }
        
        objectWillChange.send()
        questionnaires[index].isAvailable = true
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
