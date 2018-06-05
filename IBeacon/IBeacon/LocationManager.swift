//
//  LocationManager.swift
//  IBeacon
//
//  Created by Sam Meech-Ward on 2018-06-04.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate {
  func locationManager(_ manager: LocationManager, didUpdateStatus status: String)
}

class LocationManager: NSObject {
  
  var locationManager: CLLocationManager!
  var delegate: LocationManagerDelegate?
  
  var region: CLBeaconRegion!
  
  override init() {
    super.init()
    
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.requestAlwaysAuthorization()
    let uuid = UUID(uuidString: "C383E0DD-644D-473B-B280-DCD260484EA0")!
    let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "My_Beacon")
    region = beaconRegion
  }
  

  private func startScanning() {
    
    locationManager.startMonitoring(for: region)
    locationManager.startRangingBeacons(in: region)
    
  }
  
  private func updateDistance(_ distance: CLProximity) {
    
    var status: String!
    switch distance {
    case .unknown:
      status = "Unknown"
      
    case .far:
      status = "far"
      
    case .near:
      status = "near"
      
    case .immediate:
      status = "immediate"
    }
    
    delegate?.locationManager(self, didUpdateStatus: status)
    
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
      updateDistance(.unknown)
      return
      
    }
    
    updateDistance(beacon.proximity)
    print("major \(beacon.major), minor \(beacon.minor)")
  }
  
}
