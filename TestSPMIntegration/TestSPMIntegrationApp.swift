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

        let credentials = SDKCredentials(appKey: "25948be6",
                                         token: "3a6b436f863d474a8429200d0f97f1c0",
                                         secret: "1Tw31194j56K891jMSx5Pfj2vdIa2a58")
        CrowdConnected.shared.start(credentials: credentials,
                                    trackingMode: .foregroundOnly) { deviceID, result in
            guard case .success = result, let deviceID else {
                print("❌ CrowdConnected SDK has failed to start. Error: \(result.description)")
                return
            }
            print("✅ CrowdConnected SDK has started with device ID \(deviceID)")
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

// Should produce 1 Geo position if ran on a simulator.
// Should produce 1 Geo position and multiple IPS positions if ran on a device and there's a beacon nearby.
// Beacon nearby should be RFID f85fe6b8-8afb-47bf-a97b-769f2df022a9:0:123
final class LocationsProvider: CrowdConnectedDelegate {
    func didUpdateLocation(_ locations: [Location]) {
        guard let location = locations.first else {
            print("📍 CrowdConnected SDK has triggered an update with no locations")
            return
        }
        print("📍 New location update from CrowdConnected SDK. (\(location.latitude),\(location.longitude)) quality \(location.quality)")
    }
}
