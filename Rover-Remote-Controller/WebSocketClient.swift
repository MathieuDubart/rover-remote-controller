//
//  WebsocketClient.swift
//  WebSocketClient
//
//  Created by digital on 22/10/2024.
//
// IP Fixe Raspberry: 192.168.0.123
// IP Fixe MBP-Mathis: 192.168.0.112
// IP Fixe iPhone-Mathis: 192.168.0.116
// IP Fixe MBP-Mathieu: 192.168.0.115
// IP Fixe iPhone-Mathieu: 192.168.0.107

import SwiftUI
import NWWebSocket
import Network

class WebSocketClient: ObservableObject {
    struct Message: Identifiable, Equatable {
        let id = UUID().uuidString
        let content:String
    }
    
    @AppStorage("ipAdress") private var ipAdress: String?
    @AppStorage("port") private var port: String?
    
    static let shared:WebSocketClient = WebSocketClient()
    
    var routes = [String:NWWebSocket]()
    
    @Published var isConnected: Bool = false
    @Published var receivedMessages: [Message] = []
    
    func connectTo(route:String) -> Bool {
        guard let ipAdress = self.ipAdress, let port = self.port else { print("No ipAdress/port found for WS Server connection"); return false }
        
        let socketURL = URL(string: "ws://\(ipAdress):\(port)/\(route)")
        if let url = socketURL {
            let socket = NWWebSocket(url: url, connectAutomatically: true)
            
            socket.delegate = self
            socket.connect()
            routes[route] = socket
            print("Connected to WSServer @ \(url) -- Routes: \(routes)")
            return true
        }
        
        return false
    }
    
    func sendMessage(_ string: String, toRoute route:String) -> Void {
        self.routes[route]?.send(string: string)
    }
    
    /*func sendImageAndPrompt(image: UIImage, prompt: String, toRoute route: String) -> Void {
        if let imageData = image.jpegData(compressionQuality: 0.6) {
            let base64String = imageData.base64EncodedString()
            
            let jsonModel = ImagePrompting(prompt: prompt, imagesBase64Data: [base64String])
            
            if let json = try? JSONEncoder().encode(jsonModel), let jsonStringToSend = String(data: json, encoding: .utf8) {
                self.routes[route]?.send(string: jsonStringToSend)
                print("Json sent")
            } else {
                print("Error sending prompt and image")
            }
        }
    }*/
    
    func disconnect(route: String) -> Void {
        routes[route]?.disconnect()
        print("Disconnected from route: /\(route).")
    }
    
    func disconnectFromAllRoutes() -> Void {
        for route in routes {
            route.value.disconnect()
        }
        
        print("Disconnected from all routes.")
    }
}

extension WebSocketClient: WebSocketConnectionDelegate {
    
    func webSocketDidConnect(connection: WebSocketConnection) {
        // Respond to a WebSocket connection event
        print("WebSocket connected")
    }

    func webSocketDidDisconnect(connection: WebSocketConnection,
                                closeCode: NWProtocolWebSocket.CloseCode, reason: Data?) {
        // Respond to a WebSocket disconnection event
        print("WebSocket disconnected")
    }

    func webSocketViabilityDidChange(connection: WebSocketConnection, isViable: Bool) {
        // Respond to a WebSocket connection viability change event
        print("WebSocket viability: \(isViable)")
    }

    func webSocketDidAttemptBetterPathMigration(result: Result<WebSocketConnection, NWError>) {
        // Respond to when a WebSocket connection migrates to a better network path
        // (e.g. A device moves from a cellular connection to a Wi-Fi connection)
    }

    func webSocketDidReceiveError(connection: WebSocketConnection, error: NWError) {
        // Respond to a WebSocket error event
        print("WebSocket error: \(error)")
    }

    func webSocketDidReceivePong(connection: WebSocketConnection) {
        // Respond to a WebSocket connection receiving a Pong from the peer
        print("WebSocket received Pong")
    }

    func webSocketDidReceiveMessage(connection: WebSocketConnection, string: String) {
        // Respond to a WebSocket connection receiving a `String` message
        print("WebSocket received message: \(string)")
        self.receivedMessages.append(Message(content: string))
    }

    func webSocketDidReceiveMessage(connection: WebSocketConnection, data: Data) {
        // Respond to a WebSocket connection receiving a binary `Data` message
        print("WebSocket received Data message \(data)")
    }
}
