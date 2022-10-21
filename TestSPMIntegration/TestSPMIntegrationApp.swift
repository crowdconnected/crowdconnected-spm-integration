//  Created by TCode on 9/7/21.

import SwiftUI
import CoreLocation
import CrowdConnectedShared
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
            if let errorMessage = error {
                print("⚠️ CrowdConnected SDK has failed to start. Error: \(errorMessage)")
                return
            }
            if let deviceId = deviceId {
                print("✅ CrowdConnected SDK has started with device ID \(deviceId)")
                return
            }
            print("❌ CrowdConnected SDK failed to start. Invalid callback as no error and no device ID were provided.")
        }

        CrowdConnected.shared.delegate = locationsProvider
        CrowdConnected.shared.setAlias(key: "", value: "")
        CrowdConnected.shared.activateSDKBackgroundRefresh()
        CrowdConnected.shared.scheduleRefresh()

        locationManager.requestWhenInUseAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

final class LocationsProvider: CrowdConnectedDelegate {
    func didUpdateLocation(_ locations: [Location]) {
        guard let location = locations.first else {
            print("📍 CrowdConnected SDK has triggered an update with no locations")
            return
        }
        print("📍 New location update from CrowdConnected SDK. (\(location.latitude),\(location.longitude))")
    }
}
