//
//  Exercises.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 9/6/22.
//

import SwiftUI
import Foundation

class Exercise: Codable, Equatable, Identifiable {
    var id = UUID()
    let name: String
    var isUnlocked: Bool
    var type: ExerciseType
    let description: String
    var timesDoneToday = 0
    var pendingToMarkAsCompleted = false // MARK: Investigate
    var icon: String {
        name + " icon"
    }
    
    init(id: UUID = UUID(), name: String, isUnlocked: Bool, type: ExerciseType, description: String) {
        self.id = id
        self.name = name
        self.isUnlocked = isUnlocked
        self.type = type
        self.description = description
    }
    
    enum ExerciseType: Codable {
        case basic, advanced
    }
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }
    
    static var example: Exercise {
        Exercise(name: "Test Exercise", isUnlocked: true, type: .basic, description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum arcu vitae elementum curabitur vitae nunc sed. Sit amet cursus sit amet dictum sit. Habitant morbi tristique senectus et. Nunc consequat interdum varius sit amet mattis. Arcu cursus euismod quis viverra nibh. Nisl purus in mollis nunc sed id. Auctor urna nunc id cursus metus aliquam. Dolor purus non enim praesent elementum facilisis leo. Cras semper auctor neque vitae tempus quam pellentesque nec nam. Convallis tellus id interdum velit laoreet id donec. Sed viverra tellus in hac habitasse. Odio ut sem nulla pharetra diam sit amet nisl suscipit. Id ornare arcu odio ut sem nulla. Proin fermentum leo vel orci porta non pulvinar. Feugiat scelerisque varius morbi enim nunc faucibus a pellentesque. A arcu cursus vitae congue mauris rhoncus aenean vel. Nunc faucibus a pellentesque sit. Vel quam elementum pulvinar etiam. Est ultricies integer quis auctor elit sed. Lacus sed viverra tellus in hac. Mi ipsum faucibus vitae aliquet nec ullamcorper sit amet. Purus non enim praesent elementum facilisis leo vel. Vitae ultricies leo integer malesuada nunc vel risus commodo. Mollis aliquam ut porttitor leo a. Nisl vel pretium lectus quam id.")
    }
}

@MainActor class Exercises: ObservableObject {
    @Published private(set) var exercises: [Exercise] {
        didSet {
            save()
        }
    }
    
    var available: [Exercise] {
        exercises.filter { $0.isUnlocked }
    }
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent(Keys.exercises)
    
    init() {
        exercises = [
            Exercise(name: "Neck Flexion", isUnlocked: true, type: .basic, description: "Bend your neck down as if you wanted to look at the floor. Place your hands on the back of your head and gently push down on your head until you feel a slight stretch in the back of your neck. Hold this position for 15 to 30 seconds and repeat 3 to 5 times."),
            Exercise(name: "Chin tuck", isUnlocked: true, type: .basic, description: "Flatten the curve of the back of your neck as you bring your chin closer to the front of your neck. Hold the position for 3 seconds. Repeat 10 to 15 times."),
            Exercise(name: "Trapezius stretch", isUnlocked: false, type: .basic, description: "With your right arm by your side, reach over your head with your left hand to your right ear. Gently pull that side of his head until you feel a stretch in his trapezius, as if she wanted to touch his right shoulder with her left ear. She hold for 15 to 30 seconds and repeat 3 to 5 times. Do the same on the opposite side."),
            Exercise(name: "Cervical relaxation", isUnlocked: false, type: .basic, description: "Start by looking straight ahead, then bend your neck as if you want to look at the floor or bring your chin to your chest. Hold the position for 3 seconds and then return your head to the starting position. The movement should be slow and rhythmic. Repeat 10 to 15 times."),
            Exercise(name: "Head rotation and Chin tuck", isUnlocked: false, type: .basic, description: "Flatten the curve of the back of your neck as you bring your chin closer to the front of your neck. Then rotate your head to one side until you feel a stretch on the opposite side from where you rotated and perform to the other side. You can use your fingertips to guide the movement. Hold the position for 5 to 10 seconds. Repeat 5 to 10 times."),
            Exercise(name: "Side bending", isUnlocked: true, type: .basic, description: "Bringing both shoulders down and back, begin looking up with your entire head in a slow, rhythmic motion. Hold for 3 seconds and return to the starting position. Do this 10 to 15 times."),
            Exercise(name: "Upper back stretch", isUnlocked: true, type: .basic, description: "Kneel in front of a chair and place your hands on the chair with your palms facing down and your arm fully extended. Lower your chest toward the floor until you feel a stretch in your upper back and near your armpits. Hold the position for 15 to 30 seconds and repeat 3 to 5 times."),
            Exercise(name: "Cervical Rotation", isUnlocked: true, type: .basic, description: "Start by looking straight ahead and then turn your head to the right side. Hold the position for 3 seconds and return to the starting position. Then repeat the movement by turning your head to the left side. Hold the position for 3 seconds and return to the starting position. Repeat the movement 10 to 15 times on each side."),
            Exercise(name: "Lumbar stretch", isUnlocked: false, type: .basic, description: "Standing or sitting up straight, reach both arms above your head and interlock your fingers with palms facing out. Keeping your arms straight, inhale deeply and exhale while leaning from the hips to the side without twisting your trunk until you feel a stretch in your back. Hold the position for 15 to 30 seconds and repeat 3 to 5 times."),
            Exercise(name: "Scapular Retraction", isUnlocked: false, type: .basic, description: "Sitting or standing with both arms at the side of the body forming a 90 degree angle at the elbow, both thumbs pointing to the head, begin to retract both scapulae as if you wanted to bring the scapulae closer together. Hold the position for 3 seconds and repeat 10 to 15 times."),
            Exercise(name: "Cervical semicircles", isUnlocked: false, type: .advanced, description: "With both shoulders down and back, look down by flexing your neck as if you wanted to look at the ground. Then roll your head to the side slowly and rhythmically bringing your ear to the shoulder on the same side until you feel a stretch in your neck. Slowly come back to the middle and repeat to the other side. You must hold each side for 3 seconds and repeat the movement 10 to 15 times."),
            Exercise(name: "Chin tuck and trapezius stretch", isUnlocked: false, type: .advanced, description: "With both shoulders down and back, while doing a chin tuck try to bring your ear to your shoulder until you feel a stretch in your neck and hold for 3 seconds. Do the same to the opposite side. You should repeat the movement 10 to 15 times per side."),
            Exercise(name: "Neck extension", isUnlocked: false, type: .advanced, description: "Interlace 4 fingers of both hands behind the neck. Flex your neck and head, as if looking at the ground, hold for 3 seconds, and then extend your neck as if looking at the ceiling, hold for 3 seconds. You should repeat the movement 10 to 15 times."),
            Exercise(name: "Upper trapezius", isUnlocked: false, type: .advanced, description: "Tilt your head, then turn it to the side. With your hand on the side you turned, place it on the top behind your head and press down toward the floor until you feel the stretch in the back of your neck. Hold the position for 15 to 20 seconds. Do it on the opposite side. Repeat 3 to 5 times."),
            Exercise(name: "Isometric resistance", isUnlocked: false, type: .advanced, description: "With both shoulders down and back, do a little chin tuck to align the cervical area. In this position, place the palm of one hand on your forehead while flexing as if you wanted to move your hand, but do not exceed the strength of your hand. It is important that the force is done gradually, taking 2 seconds to reach the maximum resistance to tolerate. In the same way, it is important that when you remove the force, you do it gradually, taking 2 seconds to remove all the force. When you reach the maximum tolerated resistance, hold the position for 3 seconds. Do the same but place the palm of one hand on the back of your head. Extend with the resistance of your hand without going over the resistance of the hand. You must repeat this 10 times."),
            Exercise(name: "Lateral flexion", isUnlocked: false, type: .advanced, description: "With both shoulders down and back, do a little chin tuck to align the cervical area. In this position place the palm of one hand to the side of the head above the ear, laterally flex your neck as if you wanted to move your hand, but do not exceed the strength of your hand. It is important that the force is done gradually, taking 2 seconds to reach the maximum resistance to tolerate. In the same way, it is important that when you remove the force, you do it gradually, taking 2 seconds to remove all the force. When you reach the maximum tolerated resistance, hold the position for 3 seconds. Do the same but place the palm of one hand on the other side of the head. You must repeat this 10 times."),
            Exercise(name: "Trunck rotation", isUnlocked: false, type: .advanced, description: "Sitting with both feet on the ground, hug yourself by placing both hands on your shoulders. Lean forward and twist your torso by bringing one shoulder toward the ceiling and the other toward the ground. Remember to keep your chin in line with the center of your chest throughout the movement. Hold the position until you take a breath and do it to the other side. Repeat 3 to 5 times."),
            Exercise(name: "Thoracic extension", isUnlocked: false, type: .advanced, description: "Sitting with a proper posture, with the lower back against the back of the chair. Put both hands behind your head. Slowly lean your back back as you relax and breathe during the stretch. Remember to stretch as far as your body will allow without causing pain. Hold the position for 10 to 15 seconds. Repeat 5 to 10 times."),
            Exercise(name: "Chest expand", isUnlocked: false, type: .advanced, description: "Standing with both feet shoulder-width apart, cross both arms at wrist level in front of your hips. Inhale deeply as you abduct both arms, as if you are spreading wings, until your hands meet on top of your head. Hold 3 seconds. Slowly exhale as you adduct your arms, as if closing your wings, back to the starting position. repeat 10 times."),
            Exercise(name: "Scapular in W", isUnlocked: false, type: .advanced, description: "Standing or sitting with your back off the back of the chair, open your arms in a W shape with your palms facing forward. In this position bring both shoulder blades back as if you wanted to bring them together, hold for 3 seconds and return to the starting position. The movement must be rhythmic and controlled. Repeat this 10 to 15 times.")
        ]
    }
    
    func load() {
        
    }
    
    func save() {
        
    }
    
    func checkForPendingExerciseUnlock() {
        var exercisesDone = 0
        
        for exercise in exercises {
            exercisesDone
        }
    }
    
    func markIsUnlocked(exercise: Exercise){
        guard let index = exercises.firstIndex(of: exercise) else {
            fatalError("Couldn't find the exercises")
        }
        
        objectWillChange.send()
        exercises[index].isUnlocked = true
    }
}
