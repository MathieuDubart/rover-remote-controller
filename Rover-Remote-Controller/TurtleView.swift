//
//  TurtleViewx.swift
//  Accelerometer
//
//  Created by Al on 24/10/2024.
//

import SwiftUI

struct TurtleView: View {  
    // Position actuelle du crayon
    @State private var currentPosition: CGPoint = CGPoint(x: 200, y: 200)
    
    // Historique des positions pour tracer les lignes
    @State private var pathPoints: [CGPoint] = []
    
    // Direction actuelle en radians (0 = droite, pi/2 = haut, etc.)
    @State private var direction: Double = 0.0
    
    @Binding var orientation: String
    
    // Timer pour le mouvement continu
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            // Le chemin de dessin
            Path { path in
                // Si nous avons des points, trace le chemin
                if !pathPoints.isEmpty {
                    path.move(to: pathPoints.first!)
                    for point in pathPoints.dropFirst() {
                        path.addLine(to: point)
                    }
                }
            }
            .stroke(Color.blue, lineWidth: 2)
            .frame(width: 400, height: 400)
            .background(Color.white)
            .border(Color.gray)
        }.onChange(of: self.orientation) { old, new in
            
            self.orientation = new
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    // Fonction pour tourner à gauche (diminuer l'angle de direction)
    func turnLeft() {
        direction -= .pi / 8
        moveForward()
    }
    
    // Fonction pour tourner à droite (augmenter l'angle de direction)
    func turnRight() {
        direction += .pi / 8
        moveForward()
    }
    
    // Fonction pour avancer dans la direction actuelle
    func moveForward() {
        let step: CGFloat = 20.0  // distance à avancer
        let newX = currentPosition.x + step * CGFloat(cos(direction))
        let newY = currentPosition.y + step * CGFloat(sin(direction))
        let newPoint = CGPoint(x: newX, y: newY)
        
        // Met à jour le chemin et la position actuelle
        pathPoints.append(newPoint)
        currentPosition = newPoint
    }
    
    // Démarrer le timer
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.orientation == "left" {
                turnLeft()
                return
            }
            
            if self.orientation == "right" {
                turnRight()
                return
            }
            
            if self.orientation == "forward" || self.orientation == "backward"  {
                moveForward()
            }
        }
    }
    
    // Arrêter le timer
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
