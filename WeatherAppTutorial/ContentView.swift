import SwiftUI

struct ContentView: View {
    @ObservedObject var mqttManager = MQTTManager()
    @ObservedObject var locationManager = LocationManager()
    var temperature: String = "25"
    var humidity: String = "60"
    var lightIntensity: String = "800"

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // Location
                if let authorizationStatus = locationManager.authorizationStatus {
                    switch authorizationStatus {
                    case .notDetermined:
                        Text("Requesting location permission...")
                            .foregroundColor(.white)
                    case .restricted, .denied:
                        Text("Location permissions are restricted or denied.")
                            .foregroundColor(.white)
                    case .authorizedWhenInUse, .authorizedAlways:
                        Text("\(locationManager.city), \(locationManager.country)")
                            .font(.largeTitle)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .padding()
                    @unknown default:
                        Text("Unknown location authorization status.")
                            .foregroundColor(.white)
                    }
                } else {
                    Text("Checking location permissions...")
                        .foregroundColor(.white)
                }

                Spacer()

                // Weather Info
                VStack(spacing: 20) {
                    weatherTile(icon: "thermometer", title: "Temperature", value: "\(mqttManager.temperature)°C")
                                        weatherTile(icon: "drop.fill", title: "Humidity", value: "\(mqttManager.humidity)%")
                }
                                .padding()
                Spacer()
            }
        }
    }
    func weatherTile(icon: String, title: String, value: String) -> some View {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(value)
                        .font(.title)
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.2)))
            .shadow(radius: 5)
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
