//  Created by TCode on 9/7/21.

import SwiftUI
import CoreLocation
//import CrowdConnectedShared
import CrowdConnectedCore
import CrowdConnectedIPS
import CrowdConnectedCoreBluetooth
import CrowdConnectedGeo

@main
struct TestSPMIntegrationApp: App {

    let locationsProvider = LocationsProvider()
    let locationManager = CLLocationManager()

    init() {

        CrowdConnectedIPS.activate()
        CrowdConnectedCoreBluetooth.activate()
        CrowdConnectedGeo.activate()
        CrowdConnected.shared.start(appKey: "appkey", token: "iosuser", secret: "Ea80e182$") { deviceId, error in
            guard let id = deviceId else {
                // Check the error and make sure to start the library correctly
                return
            }

            // Library started successfully
        }

        CrowdConnected.shared.delegate = locationsProvider
        CrowdConnected.shared.setAlias(key: "", value: "")

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
