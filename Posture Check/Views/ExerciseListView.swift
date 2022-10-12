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
    @EnvironmentObject var appSetting: AppSettings
    @EnvironmentObject var user: User
    @State private var showAsGrid = true
    
    var filteredExercises: [Exercise] {
        let unlocked = user.exercises.exercises.filter {
            $0.isUnlocked
        }
          
        let locked = user.exercises.exercises.filter {
            !$0.isUnlocked
        }
        
        return unlocked + locked
    }
    
    var body: some View {
        NavigationView {
            Group {
                if showAsGrid {
                    GridView(exercises: filteredExercises)
                } else {
                    ListView(exercises: filteredExercises)
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

struct ListView: View {
    let exercises: [Exercise]
    @State private var searchText = ""
    
    var filteredExercises: [Exercise] {
        if searchText.isEmpty {
            return exercises
        } else {
            return exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredExercises) { exercise in
                NavigationLink {
                    ExerciseDetailView(exercise: exercise)
                } label: {
                    HStack {
                        Text(exercise.name)
                        
                        Spacer()
                        
                        if !exercise.isUnlocked {
                            Image(systemName: "lock")
                                .scaledToFit()
                                .foregroundColor(.primary)
                        }
                    }
                }
                .disabled(!exercise.isUnlocked)
            }
        }
        .searchable(text: $searchText, prompt: "Search exercises")
    }
}

struct GridView: View {
    let exercises: [Exercise]
    let columns = [
        GridItem(.adaptive(minimum: 150))
//        GridItem(.flexible()),
//        GridItem(.flexible())
    ]
    
    @State private var searchText = ""
    
    var filteredExercises: [Exercise] {
        if searchText.isEmpty {
            return exercises
        } else {
            return exercises.filter { $0.name.localizedCaseInsensitiveContains(searchText)}
        }
    }
        
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(filteredExercises) { exercise in
                    NavigationLink {
                        ExerciseDetailView(exercise: exercise)
                    } label: {
                        ExerciseView(exercise: exercise)
                    }
                    .disabled(!exercise.isUnlocked)
                }
            }
        }
    }
}

struct ExerciseView: View {
    var exercise: Exercise
    
    init(exercise: Exercise) {
        self.exercise = exercise
    }
    
    var body: some View {
        ZStack(alignment: .center){
            VStack(alignment: .center) {
            
                ZStack {
//                    Image(exercise.icon) // For some reason some images names cannot be found by SwiftUI Image View but always found by UIImage, this bug should be investigated on another release.
                    Image(uiImage: UIImage(named: exercise.icon)!)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding([.top, .horizontal], 5)
                
              // if !exercise.isUnlocked {
               //    Image(systemName: "lock")
                 //       .font(.largeTitle)
                  //         .foregroundColor(.primary)
                        
                        
               // }
            
                }
            
                Text(exercise.name)
                  .font(.title3)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(height: 40)
                    .foregroundColor(.white)
                    .padding(.bottom)
            
            }
            
            if !exercise.isUnlocked {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(.gray.opacity(0.6))
                Image(systemName: "lock")
                    .resizable()
                    .scaledToFit()
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .frame(width: 80, height: 80)
            }
            
        }
        .background(.indigo)
        .clipShape(RoundedRectangle(cornerRadius: 5))
        .padding()
    }
}

struct ExerciseListView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseListView()
            .environmentObject(User())
            .environmentObject(AppSettings())
    }
}
