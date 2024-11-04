//
//  ConfigView.swift
//  TP-swift-avance
//
//  Created by Mathieu DUBART on 04/11/2024.
//

import SwiftUI

struct ConfigView: View {
    @AppStorage("ipAdress") private var ipAdress: String = ""
    @AppStorage("port") private var port: String = ""
    @AppStorage("movementsRoute") private var movementsRoute: String = ""
    @AppStorage("imageRecoRoute") private var imageRecoRoute: String = ""
    @AppStorage("ttsRoute") private var ttsRoute: String = ""
    @AppStorage("connectionRoute") private var connectionRoute: String = ""
    @AppStorage("speedMultiplier") private var speedMultiplier: Double = 1
    @AppStorage("sensibilityX") private var sensibilityX: Double = 1
    @AppStorage("sensibilityY") private var sensibilityY: Double = 1
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section("Network") {
                    TextField("IP", text: $ipAdress)
                    TextField("Port", text: $port)
                }
                
                Section("Routes"){
                    TextField("Movements", text: $movementsRoute)
                    TextField("ImageReco", text: $imageRecoRoute)
                    TextField("TTS", text: $ttsRoute)
                    TextField("Connect", text: $connectionRoute)
                }
                
                Section("Settings"){
                    Stepper("Speed: \(speedMultiplier, specifier: "%.1f")", value: $speedMultiplier, in: 0...5, step: 0.1)
                    Stepper("Sensibility X: \(sensibilityX, specifier: "%.1f")", value: $sensibilityX, in: 0...5, step: 0.1)
                    Stepper("Sensibility Y: \(sensibilityY, specifier: "%.1f")", value: $sensibilityY, in: 0...5, step: 0.1)
                }
            }
            .scrollDisabled(true)
        }
        .navigationTitle("Config")
        .padding()
    }
}

#Preview {
    ConfigView()
}
