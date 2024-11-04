//
//  AccelerometerManager.swift
//  Accelero
//
//  Created by digital on 24/10/2024.
//

import SwiftUI
import CoreMotion
import Combine

struct AccelerometerValues: Equatable, Identifiable {
    let id = UUID()
    let x: Double
    let y: Double
    let z: Double
    let timestamp: Date
    
    func toString() -> String {
        return "x:\(String(format: "%.2f", self.x)) y:\(String(format: "%.2f", self.y)) z:\(String(format: "%.2f", self.z))"
    }
}


class AccelerometerManager: ObservableObject {
    private var motionManager = CMMotionManager()
    
    
    @Published var accelerometerValues = AccelerometerValues(x: 0, y: 0, z: 0, timestamp: Date.now)
    @Published var position: String = "Stable"
    @Published var accelerometerData: [AccelerometerValues] = []
    
    @AppStorage("sensibilityX") var sensibilityX: Double?
    @AppStorage("sensibilityY") var sensibilityY: Double?
    
    init() {
        startAccelerometerUpdates()
    }
    
    public func startAccelerometerUpdates() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.05
            
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] data, error in
                guard let data = data else { return }
                guard let sX = self?.sensibilityX, let sY = self?.sensibilityY else { return }
                let newValues = AccelerometerValues(x: data.acceleration.x, y: data.acceleration.y, z: data.acceleration.z, timestamp: Date.now)
                self?.accelerometerValues = newValues
                self?.accelerometerData.append(newValues)
                self?.updatePosition(sensibilityX: sX, sensibilityY: sY)
            }
        }
    }

    private func updatePosition(sensibilityX:Double, sensibilityY: Double) {
        if accelerometerValues.z > sensibilityY {
            position = "forward"
        } else if accelerometerValues.z < -sensibilityY {
            position = "backward"
        } else if accelerometerValues.x > sensibilityX {
            position = "right"
        } else if accelerometerValues.x < -sensibilityX {
            position = "left"
        } else {
            position = "forward"
        }
    }
    
    deinit {
        motionManager.stopAccelerometerUpdates()
    }
}
