//
//  SheetView.swift
//  TP-swift-avance
//
//  Created by Mathieu DUBART on 04/11/2024.
//

import SwiftUI

struct SheetView: View {
    @EnvironmentObject var accelerometerManager: AccelerometerManager
    @Environment(\.dismiss) var dismiss
    @ObservedObject var wsClient = WebSocketClient.shared
    
    @AppStorage("ipAdress") private var ipAdress: String?
    @AppStorage("port") private var port: String?
    @AppStorage("movementsRoute") private var movementsRoute: String?
    
    var body: some View {
        VStack {
            HStack {
                Text("Connected to \(ipAdress ?? "No IP Adress"):\(port ?? "No port")")
                    .font(.headline)
                
                Spacer()
                
                Button("Disconnect") {
                    dismiss()
                }
            }
            
            Spacer()
                .frame(height: 20)
            
            TurtleView(orientation: $accelerometerManager.position)
            Button("Send data") {}
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.0)
                        .onEnded({ _ in })
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onChanged({ value in
                            switch value {
                            case .second(true, _):
                                guard let movementsRoute = movementsRoute else { return }
                                wsClient.sendMessage("python3 \(accelerometerManager.position).py", toRoute: movementsRoute)
                            default:
                                break
                            }
                        })
                )
        }
        .padding()
        .onAppear {
            accelerometerManager.startAccelerometerUpdates()
        }
    }
}

#Preview {
    @Previewable var accelerometerManager = AccelerometerManager()
    SheetView().environmentObject(accelerometerManager)
}
