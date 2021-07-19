//  Created by TCode on 9/7/21.

import SwiftUI
import CoreLocation
import CrowdConnectedCore
import CrowdConnectedIPS
import CrowdConnectedShared

@main
struct TestSPMIntegrationApp: App {

    let locationsProvider = LocationsProvider()
    let locationManager = CLLocationManager()

    init() {

        CrowdConnectedIPS.activate()
        CrowdConnected.shared.start(appKey: "YOUR_APP_KEY", token: "YOUR_TOKEN", secret: "YOUR_SECRET") { deviceId, error in
            guard let id = deviceId else {
                // Check the error and make sure to start the library correctly
                return
            }

            // Library started successfully
        }

        CrowdConnected.shared.delegate = locationsProvider
        locationManager.requestWhenInUseAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class LocationsProvider: CrowdConnectedDelegate {
    func didUpdateLocation(_ locations: [Location]) {
        // Use the location updates as you need
    }
}
