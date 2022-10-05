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
        var questionnaires = [Questionnaire]()
        
        questionnaires = [
            Questionnaire(name: "Sociodemographic", url: URL(string: "https://www.apple.com")!, isAvailable: true, type: .oneTime, dateExpectedToBeCompleted: Date.now),
            Questionnaire(name: "Auto Perception of Posture", url: URL(string: "https://www.apple.com")!, type: .startAndMonthly, dateExpectedToBeCompleted: Date.now),
            Questionnaire(name: "Auto Perception of Posture", url: URL(string: "https://www.apple.com")!, type: .startAndMonthly, dateExpectedToBeCompleted: Date.now.modifyDateFor(days: 29)),
            Questionnaire(name: "Satisfaction", url: URL(string: "https://www.apple.com")!, type: .oneTime, dateExpectedToBeCompleted: Date.now.modifyDateFor(days: 29))
        ]
        
        // Creating Daily Questionnaires
        //        for day in 0..<44 {
        let dailyQuestionnaire = Questionnaire(name: "Daily Exercise Report", url: URL(string: "https://www.apple.com")!, type: .daily, dateExpectedToBeCompleted: Date.now)
        questionnaires.append(dailyQuestionnaire)
        //        }
        
        // Creating Numeric Pain Rating Questionnaires
        for day in [0, 14, 29, 44] {
            let questionnaire = Questionnaire(name: "Numeric Pain Rating Scale", url: URL(string: "https://www.apple.com")!, type: .everyFifteenDays, dateExpectedToBeCompleted: Date.now.modifyDateFor(days: day))
            questionnaires.append(questionnaire)
        }
        
        return questionnaires
    }
    
    func unlockQuestionnairesPending() { // Posible Bug with one time questionnaire see bug in github
        let currentDate = Date.now.dateWithoutHours()
        for questionnaire in questionnaires {
            if questionnaire.dateExpectedToBeCompleted.dateWithoutHours() < currentDate || questionnaire.dateExpectedToBeCompleted.dateWithoutHours() == currentDate {
                unlockQuestionnaire(questionnaire)
            }
        }
    }
    
    func markAsCompleted(_ questionnaire: Questionnaire) {
        guard let index = questionnaires.firstIndex(of: questionnaire) else {
            fatalError("Couldn't find the questionnaire!")
        }
        
        print("Pre-Modified questionnaire: \(questionnaires[index].description)")
        
        objectWillChange.send()
        
        // MARK: TODO Don't let this code run if the questionnaire has been unlocked multiples times before using a limit.
        switch questionnaire.type {
        case .oneTime:
            break
        case .everyFifteenDays:
            questionnaires[index].dateExpectedToBeCompleted = Date.now.modifyDateFor(days: 15)
        case .startAndMonthly:
            questionnaires[index].dateExpectedToBeCompleted = Date.now.modifyDateFor(days: 29)
        case .daily:
            questionnaires[index].dateExpectedToBeCompleted = Date.now.modifyDateFor(days: 1)
        case .satisfaction:
            break
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
