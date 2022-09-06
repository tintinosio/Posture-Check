//
//  ExerciseListView.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 8/29/22.
//

// MARK: File Description
/*
 This view will be responsible for hosting all unlocked and non unlocked exercises it will be also the view responsible to segue to ExerciseDetailView. The list will be initialized via an environment object.
 */

import SwiftUI

struct ExerciseListView: View {
    @EnvironmentObject var exercises: Exercises
    @State private var showAsGrid = true
    
    var body: some View {
        NavigationView {
            List {
                ForEach(exercises.exercises, id: \.id) { exercise in
                    NavigationLink {
                        ExerciseDetailView(exercise: exercise) 
                    } label: {
                        Text(exercise.name)
                    }
                }
            }
            .navigationTitle("Exercise")
            .toolbar {
                Button() {
                    showAsGrid.toggle()
                } label: {
                    Text(showAsGrid ? "Show as List" : "Show as Grid")
                }
            }
        }
    }
}

struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
            ExerciseListView()
            .environmentObject(Exercises())
    }
}
