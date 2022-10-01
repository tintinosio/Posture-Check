//
//  ConditionalQuestionnaireView.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 9/30/22.
//

import SwiftUI

struct ConditionalQuestionnaireView: View {
    @EnvironmentObject var questionnaires: Questionnaires

    var body: some View {
        Group {
            if questionnaires.isAnyQuestionnaireAvailable {
                QuestionnaireView()
                    .badge(questionnaires.questionnairesAvailableCount)
            } else {
                QuestionnaireView()
            }
        }
    }
}

struct ConditionalQuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        ConditionalQuestionnaireView()
    }
}
