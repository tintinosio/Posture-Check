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
    
    
    func markIsUnlocked(exercise:Exercise)
{
     guard let index = exercise.firstIndex(of:exercise)
     else
     {
        
     fatalError("Couldn't find the exercises")
     }
     
     objectWillchange.send()
     
     exercises[index].isUnlocked=true
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
            Exercise(name: "Neck Flexion", isUnlocked: true, type: .basic, description: "Doble el cuello hacia abajo como si quisiera mirar el piso. Coloque las manos en la parte de atrás de la cabeza y empuje levemente hacia abajo la cabeza hasta que sienta un leve estiramiento en la parte de atrás del cuello. Mantén esta posición por 15 a 30 segundos y repita de 3 a 5 veces."),
            Exercise(name: "Chin tuck", isUnlocked: true, type: .basic, description: "Aplane la curvatura de la parte de atrás del cuello mientras acerca la barbilla a la parte delantera de su cuello. Mantenga la posición 3 segundos. Repite 10 a 15 veces."),
            Exercise(name: "Trapezius stretch", isUnlocked: true, type: .basic, description: "Con el brazo derecho al lado del cuerpo, debe alcanzar sobre la cabeza con la mano izquierda la oreja derecha. Hale cuidadosamente ese lado de la cabeza hasta sentir un estiramiento en su trapecio, como si deseara tocar su hombro derecho con la oreja izquierda. Sostenga por 15 a 30 segundos y repita de 3 a 5 veces. Haga lo mismo en el lado opuesto."),
            Exercise(name: "Cervical relaxation ", isUnlocked: true, type: .basic, description: "Comience mirando hacia adelante, luego doble el cuello como si quisiera mirar al piso o llevar la barbilla hacia el pecho. Sostén la posición por 3 segundos y luego regresa la cabeza a la posición inicial. El movimiento debe ser lento y rítmico. Repite de 10 a 15 veces."),
            Exercise(name: "Head rotation and Chin tuck", isUnlocked: true, type: .basic, description: "Aplane la curvatura de la parte de atrás del cuello mientras acerca la barbilla a la parte delantera de su cuello. Luego rote su cabeza hacia un lado hasta sentir estiramiento en el lado contrario hacia donde giró y realice hacia el otro lado. Puede utilizar la punta de sus dedos para orientar el movimiento. Mantenga la posición de 5 a 10 segundos. Repite 5 a 10 veces."),
            Exercise(name: "Side bending", isUnlocked: true, type: .basic, description: "Llevando ambos hombros hacia abajo y hacia atrás, comience a mirar hacia arriba con toda la cabeza en un movimiento lento y rítmico. Sostenga por 3 segundos y vuelva a la posición inicial. Haga esto 10 a 15 veces."),
            Exercise(name: "Upper back stretch", isUnlocked: true, type: .basic, description: "Arrodíllate delante de una silla y coloca las manos sobre la silla con las palmas hacia abajo y el brazo completamente estirado. Baje el pecho hacia el suelo hasta que sienta estiramiento en la parte alta de la espalda y cerca de las axilas. Sostén la posición de 15 a 30 segundos y repita de 3 a 5 veces."),
            Exercise(name: "Cervical Rotation", isUnlocked: true, type: .basic, description: "Comienza mirando hacia adelante y luego gira la cabeza hacia el lado derecho. Sostén la posición por 3 segundos y regresa a la posición inicial. Luego repite el movimiento girando la cabeza hacia el lado izquierdo. Sostén la posición por 3 segundos y vuelve a la posición inicial. Repite el movimiento de 10 a 15 veces en cada lado"),
            Exercise(name: "Lumbar Stretch", isUnlocked: false, type: .basic, description: "Parado o sentado derecho, lleva ambos brazos por encima de la cabeza y entrelace los dedos con las palmas hacia afuera. Mientras mantiene los brazos estirados inhale profundamente y exhale mientras se inclina desde la cadera a un lado sin girar el tronco hasta sentir un estiramiento en la espalda. Sostenga la posición de 15 a 30 segundos y repita de 3 a 5 veces."),
            Exercise(name: "Scapular Retraction", isUnlocked: false, type: .basic, description: "Sentado o de pie con ambos brazos al lado del cuerpo formando un ángulo de 90 grados en el codo, ambos pulgares apuntando a la cabeza, comience a hacer una retracción de ambas escápulas como si quisiera acercar las escápulas. Sostenga la posición 3 segundos y repita 10 a 15 veces."),
            Exercise(name: "Cervical semicircles", isUnlocked: false, type: .advanced, description: "Con ambos hombros hacia abajo y atrás, mire hacia abajo flexionando su cuello como si deseara mirar el suelo. Luego ruede su cabeza hacia el lado lenta y rítmicamente llevando su oreja hacia el hombro del mismo lado hasta sentir un estiramiento en el cuello. Lentamente vuelva al medio y repita hacia el otro lado. Debe sostener cada lado 3 segundos y repetir el movimiento de 10 a 15 veces."),
            Exercise(name: "Chin tuck and trapezius stretch", isUnlocked: false, type: .advanced, description: "Con ambos hombros hacia abajo y atrás, mientras hace un chin tuck intente llevar su oreja a su hombro hasta sentir un estiramiento en el cuello y sostenga por 3 segundos. Haga lo mismo hacia el lado opuesto. Debe repetir el movimiento 10 a 15 veces por lado."),
            Exercise(name: "Neck extension", isUnlocked: false, type: .advanced, description: "Entrelace 4 dedos de ambas manos detrás del cuello. Flexione su cuello y cabeza, como si deseara mirar el suelo, sostenga por 3 segundos y luego extienda su cuello como si deseara mirar el techo, sostenga por 3 segundos. Debe repetir el movimiento de 10 a 15 veces."),
            Exercise(name: "Upper trapezius", isUnlocked: false, type: .advanced, description: "Incline la cabeza, luego gírela hacia un lado. Con la mano hacia el lado que giró, colóquela en la parte superior atrás de su cabeza y presione en dirección hacia el suelo hasta sentir el estiramiento en la parte posterior de su cuello. Mantenga la posición de 15 a 20 segundos. Realizalo en el lado contrario. Repita 3 a 5 veces."),
            Exercise(name: "Isometric resistance", isUnlocked: false, type: .advanced, description: "Con ambos hombros hacia abajo y atrás, haga un poco de chin tuck para alinear el área cervical. En esta posición ponga la palma de una mano en la frente mientras hace fuerza en flexión como si deseara mover la mano, pero no debe sobrepasar la fuerza de su mano. Es importante que la fuerza la haga de manera gradual tomando 2 segundos llegar a la máxima resistencia a tolerar. De igual manera es importante que al quitar la fuerza lo haga de manera gradual tardando 2 segundos en quitar toda la fuerza. Cuando llegue a la resistencia máxima tolerada mantenga la posición por 3 segundos. Haga lo mismo pero colocando la palma de una mano en la parte de atrás de su cabeza. Haga una extensión con la resistencia de su mano sin sobrepasar la resistencia de la mano. Debe repetir esto 10 veces."),
            Exercise(name: "Lateral flexion", isUnlocked: false, type: .advanced, description: "Con ambos hombros hacia abajo y atrás, haga un poco de chin tuck para alinear el área cervical. En esta posición ponga la palma de una mano al lado de la cabeza por encima de la oreja, haga una flexión lateral de cuello como si deseara mover la mano, pero no debe sobrepasar la fuerza de su mano. Es importante que la fuerza la haga de manera gradual tomando 2 segundos llegar a la máxima resistencia a tolerar. De igual manera es importante que al quitar la fuerza lo haga de manera gradual tardando 2 segundos en quitar toda la fuerza. Cuando llegue a la resistencia máxima tolerada mantenga la posición por 3 segundos. Haga lo mismo pero colocando la palma de una mano en el otro lado de la cabeza. Debe repetir esto 10 veces."),
            Exercise(name: "Trunck rotation ", isUnlocked: false, type: .advanced, description: "Sentado con ambos pies en el suelo, abrazate colocando ambas manos en los hombros. Inclínate hacia adelante y gira el tronco llevando un hombro hacia el techo y el otro hacia el suelo. Recuerda mantener la barbilla alineada con el centro de tu pecho durante el movimiento. Mantenga la posición hasta lograr una respiración y realizalo hacia el otro lado. Repita 3 a 5 veces."),
            Exercise(name: "Thoracic extension", isUnlocked: false, type: .advanced, description: "Sentado con una postura adecuada, con la espalda baja pegada al espaldar de la silla. Coloque ambas manos detrás de la cabeza. Lentamente incline la espalda hacia atrás mientras se relaja y respira durante el estiramiento. Recuerda estirarte hasta donde tu cuerpo te lo permita sin provocar dolor. Mantén la posición de 10 a 15 segundos. Repite de 5 a 10 veces."),
            Exercise(name: "Chest expand", isUnlocked: false, type: .advanced, description: "arado con ambos pies a lo ancho de los hombros, cruce ambos brazos a nivel de las muñecas frente a su cadera. Inhale profundamente mientras abduce ambos brazos, como si estuviera abriendo unas alas, hasta que las manos se encuentren en la parte superior de su cabeza. Sostenga 3 segundos. Exhale lentamente mientras adduce los brazos, como si cerrara las alas, hasta llegar a la posición inicial. Repita 10 veces."),
            Exercise(name: "Scapular in W", isUnlocked: false, type: .advanced, description: "Parado o sentado con la espalda despegada del espaldar de la silla, abra sus brazos formando una W con las palmas mirando hacia al frente. En esta posición lleve ambas escápulas hacia atrás como si deseara juntarlas, sostenga por 3 segundos y vuelva a la posición inicial. El movimiento debe ser rítmico y controlado. Repita esto 10 a 15 veces."),
        ]
    }
    
    func load() {
        
    }
    
    func save() {
        
    }
}
