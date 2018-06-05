//
//  LocationManager.swift
//  CannaCity
//
//  Created by Sam Meech-Ward on 2018-06-05.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
  
  var manager: CLLocationManager!
  var beacon: CLBeaconRegion!
  
  override init() {
    super.init()
    manager = CLLocationManager()
    manager.delegate = self
    manager.requestAlwaysAuthorization()
    
    let uuid = UUID(uuidString: "5c2c4f9a-1df1-4afd-859a-82b301e1e63f")!
    beacon = CLBeaconRegion(proximityUUID: uuid, identifier: "my-420-beacon")
  }
  
  private func startScanning() {
    print("Scanning...")
    manager.startMonitoring(for: beacon)
    manager.startRangingBeacons(in: beacon)
  }
}

extension LocationManager: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    if status == .authorizedAlways {
      if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
        if CLLocationManager.isRangingAvailable() {
          startScanning()
        }
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    
    guard let beacon = beacons.first else {
      print("NO beacon")
      return
    }
    print("proximity \(beacon.proximity.rawValue), major \(beacon.major), minor \(beacon.minor)")
  }
  
}
