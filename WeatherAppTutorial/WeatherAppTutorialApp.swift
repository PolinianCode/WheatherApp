//
//  WeatherAppTutorialApp.swift
//  WeatherAppTutorial
//
//  Created by Даня Коваль on 27/05/2024.
//

import SwiftUI

@main
struct WeatherAppTutorialApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                temperature: "25",
                humidity: "60",
                lightIntensity: "800"
            )
        }
    }
}
