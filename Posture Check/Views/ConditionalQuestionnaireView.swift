//
//  ConditionalQuestionnaireView.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 9/30/22.
//

import SwiftUI

struct ConditionalQuestionnaireView: View {
    @EnvironmentObject var user: User

    var body: some View {
        Group {
            if user.questionnaires.isAnyQuestionnaireAvailable {
                QuestionnaireView()
                    .badge(user.questionnaires.questionnairesAvailableCount)
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
