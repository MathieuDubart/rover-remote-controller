//
//  ContentView.swift
//  Accelero
//
//  Created by digital on 24/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var accelerometerManager = AccelerometerManager()
    @ObservedObject var wsClient = WebSocketClient.shared
    @State var connectedToServer: Bool = false
    @AppStorage("movementsRoute") private var movementsRoute: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Connect to server") {
                    guard let movementsRoute = self.movementsRoute else {return}
                    connectedToServer = wsClient.connectTo(route: movementsRoute)
                }
            }
            .padding()
            .toolbar {
                NavigationLink("Configuration"){
                    ConfigView()
                }
            }
        }
        .sheet(isPresented: $connectedToServer){
            SheetView()
                .environmentObject(accelerometerManager)
                .onDisappear {
                    wsClient.disconnectFromAllRoutes()
                }
        }
    }
}

#Preview {
    ContentView()
}
