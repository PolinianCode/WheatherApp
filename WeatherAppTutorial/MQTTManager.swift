import Foundation
import SwiftMQTT

class MQTTManager: NSObject, ObservableObject, MQTTSessionDelegate {
    private var mqttSession: MQTTSession!
    @Published var temperature: String = "0"
    @Published var humidity: String = "0"
    @Published var lightIntensity: String = "0"

    override init() {
        super.init()
        establishConnection()
    }

    func establishConnection() {
        let host = "192.168.31.64"
        let port: UInt16 = 1883
        let clientID = UUID().uuidString

        mqttSession = MQTTSession(host: host, port: port, clientID: clientID, cleanSession: true, keepAlive: 15, useSSL: false)
        mqttSession.delegate = self

        mqttSession.connect { (error) in
            if error == .none {
                self.subscribeToChannels()
            } else {
                print("Error occurred during connection: \(error.description)")
            }
        }
    }

    func subscribeToChannels() {
        let topics = ["home/sensors/temperature", "home/sensors/humidity"]
        for topic in topics {
            mqttSession.subscribe(to: topic, delivering: .atLeastOnce) { (error) in
                if error == .none {
                    print("Subscribed to \(topic)")
                } else {
                    print("Error occurred during subscription to \(topic): \(error.description)")
                }
            }
        }
    }

    func mqttDidReceive(message: MQTTMessage, from session: MQTTSession) {
        guard let payload = message.stringRepresentation else { return }

        switch message.topic {
        case "home/sensors/temperature":
            DispatchQueue.main.async {
                self.temperature = payload
                print(payload)
            }
        case "home/sensors/humidity":
            DispatchQueue.main.async {
                self.humidity = payload
                print(payload)
            }
        default:
            break
        }
    }

    func mqttDidDisconnect(session: MQTTSession, error: MQTTSessionError) {
        print("Session Disconnected. Error: \(error.description)")
    }

    func mqttDidAcknowledgePing(from session: MQTTSession) {
        print("Keep-alive ping acknowledged.")
    }

    func publishMessage(_ message: String, to topic: String) {
        guard let data = message.data(using: .utf8) else { return }
        mqttSession.publish(data, in: topic, delivering: .atMostOnce, retain: false) { (error) in
            if error == .none {
                print("Published \(message) on channel \(topic)")
            } else {
                print("Error occurred during publish: \(error.description)")
            }
        }
    }
}
