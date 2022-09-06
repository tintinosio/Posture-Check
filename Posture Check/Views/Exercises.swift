//
//  Exercises.swift
//  Posture Check
//
//  Created by Luis Rivera Rivera on 9/6/22.
//

import SwiftUI

class Exercise: Codable, Equatable, Identifiable {
    var id = UUID()
    let name: String
    var isUnlocked: Bool
    var type: ExerciseType
    let description: String
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
    @Published private(set) var exercises: [Exercise]
    
    let savePath = FileManager.documentsDirectory.appendingPathComponent(Keys.exercises)
    
    
    init() { // Hay un typo strech -> stretch
        exercises = [
            Exercise(name: "A) 1. Neck Flexion", isUnlocked: true, type: .basic, description: "Doble el cuello hacia abajo como si quisiera mirar el piso. Coloque las manos en la parte de atrás de la cabeza y empuje levemente hacia abajo la cabeza hasta que sienta un leve estiramiento en la parte de atrás del cuello. Mantén esta posición por 15 a 30 segundos y repita de 3 a 5 veces."),
            Exercise(name: "B)2. Chin tuck", isUnlocked: true, type: .basic, description: "Aplane la curvatura de la parte de atrás del cuello mientras acerca la barbilla a la parte delantera de su cuello. Mantenga la posición 3 segundos. Repite 10 a 15 veces."),
            Exercise(name: "C) 3. Trapezius strech", isUnlocked: false, type: .basic, description: "Con el brazo derecho al lado del cuerpo, debe alcanzar sobre la cabeza con la mano izquierda la oreja derecha. Hale cuidadosamente ese lado de la cabeza hasta sentir un estiramiento en su trapecio, como si deseara tocar su hombro derecho con la oreja izquierda. Sostenga por 15 a 30 segundos y repita de 3 a 5 veces. Haga lo mismo en el lado opuesto."),
            Exercise(name: "D) 4. Cervical relaxation ", isUnlocked: false, type: .basic, description: "Comience mirando hacia adelante, luego doble el cuello como si quisiera mirar al piso o llevar la barbilla hacia el pecho. Sostén la posición por 3 segundos y luego regresa la cabeza a la posición inicial. El movimiento debe ser lento y rítmico. Repite de 10 a 15 veces."),
            Exercise(name: "E) 5. Head rotation and Chin tuck", isUnlocked: false, type: .basic, description: "Aplane la curvatura de la parte de atrás del cuello mientras acerca la barbilla a la parte delantera de su cuello. Luego rote su cabeza hacia un lado hasta sentir estiramiento en el lado contrario hacia donde giró y realice hacia el otro lado. Puede utilizar la punta de sus dedos para orientar el movimiento. Mantenga la posición de 5 a 10 segundos. Repite 5 a 10 veces."),
            Exercise(name: "F) 6. Side bending", isUnlocked: true, type: .basic, description: "Llevando ambos hombros hacia abajo y hacia atrás, comience a mirar hacia arriba con toda la cabeza en un movimiento lento y rítmico. Sostenga por 3 segundos y vuelva a la posición inicial. Haga esto 10 a 15 veces."),
            Exercise(name: "G) 7. Upper back strech", isUnlocked: true, type: .basic, description: "Arrodíllate delante de una silla y coloca las manos sobre la silla con las palmas hacia abajo y el brazo completamente estirado. Baje el pecho hacia el suelo hasta que sienta estiramiento en la parte alta de la espalda y cerca de las axilas. Sostén la posición de 15 a 30 segundos y repita de 3 a 5 veces."),
            Exercise(name: "H)8. Cervical Rotation ", isUnlocked: true, type: .basic, description: "Comienza mirando hacia adelante y luego gira la cabeza hacia el lado derecho. Sostén la posición por 3 segundos y regresa a la posición inicial. Luego repite el movimiento girando la cabeza hacia el lado izquierdo. Sostén la posición por 3 segundos y vuelve a la posición inicial. Repite el movimiento de 10 a 15 veces en cada lado"),
            Exercise(name: "I) 9. Lumbar Strech", isUnlocked: false, type: .basic, description: "Parado o sentado derecho, lleva ambos brazos por encima de la cabeza y entrelace los dedos con las palmas hacia afuera. Mientras mantiene los brazos estirados inhale profundamente y exhale mientras se inclina desde la cadera a un lado sin girar el tronco hasta sentir un estiramiento en la espalda. Sostenga la posición de 15 a 30 segundos y repita de 3 a 5 veces."),
            Exercise(name: "J) 10. Scapular Retraction", isUnlocked: false, type: .basic, description: "Sentado o de pie con ambos brazos al lado del cuerpo formando un ángulo de 90 grados en el codo, ambos pulgares apuntando a la cabeza, comience a hacer una retracción de ambas escápulas como si quisiera acercar las escápulas. Sostenga la posición 3 segundos y repita 10 a 15 veces."),
        ]
    }
}
