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
        CrowdConnected.shared.start(appKey: "appkey", token: "iosuser", secret: "Ea80e182$") { deviceId, error in
            guard let id = deviceId else {
                return
            }

            print(id)
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
        print("Got new location update")
    }
}
