import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var city: String = "Unknown"
    @Published var country: String = "Unknown"
    @Published var authorizationStatus: CLAuthorizationStatus?

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        reverseGeocode(location: location)
    }

    func reverseGeocode(location: CLLocation) {
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error in reverse geocoding: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                self.city = placemark.locality ?? "Unknown"
                self.country = placemark.country ?? "Unknown"
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                self.locationManager.startUpdatingLocation()
            case .denied, .restricted:
                print("Location permission denied/restricted.")
            case .notDetermined:
                print("Location permission not determined.")
                self.locationManager.requestWhenInUseAuthorization()
            @unknown default:
                print("Unknown location authorization status.")
            }
        }
    }
}
