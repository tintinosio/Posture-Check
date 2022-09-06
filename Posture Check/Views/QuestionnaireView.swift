//
//  QuestionnaireView.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 8/29/22.
//

// MARK: File Description
/*
 This view will be responsible for displaying all questionnaires related to app study.
 */

import SwiftUI

struct QuestionnaireView: View {
    @EnvironmentObject var questionnaires: Questionnaires
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(questionnaires.questionnaires, id:\.id) { questionnaire in
                        FormView(questionnaire: questionnaire) { questionnaire in
                            questionnaires.markAsCompleted(questionnaire)
                        }
                    }
                }
                .padding(.horizontal)
                .navigationTitle("Questionnaires")
            }
        }
    }
}

struct FormView: View {
    let questionnaire: Questionnaire
    @Environment(\.openURL) var openURL
    var markAsCompleted: (Questionnaire) -> Void
    
    var body: some View {
        Group {
            VStack(spacing: 5) {
                HStack {
                    Text(questionnaire.name)
                        .font(.title2)
                    
                    Spacer()
                    
                    
                    if questionnaire.isAvailable {
                        Image(systemName: "square.and.pencil")
                            .font(.largeTitle)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                openURL.callAsFunction(questionnaire.url)
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    markAsCompleted(questionnaire)
                                }
                            }
                            .offset(CGSize(width: 0.0, height: 15.0))
                    }
                    
                    if questionnaire.isCompleted {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                            .offset(CGSize(width: 0.0, height: 5.0))
                    }
                    
                }
                
                HStack {
                    if !questionnaire.isCompleted {
                        Text(questionnaire.isAvailable ? "Available" : "Available on day mm-dd-yy")
                            .font(.callout.bold())
                            .foregroundColor(questionnaire.isAvailable ? .green : .primary)
                    }
                    
                    Spacer()
                }
            }
            .padding(.all)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

struct QuestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionnaireView()
            .environmentObject(Questionnaires())
    }
}
