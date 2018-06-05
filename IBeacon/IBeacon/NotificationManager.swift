//
//  NotificationManager.swift
//  IBeacon
//
//  Created by Sam Meech-Ward on 2018-06-04.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation

class NotificationManager: NSObject {
  
  var notificationCenter: UNUserNotificationCenter!
  var locationManager: LocationManager!
  
  convenience init(locationManager: LocationManager) {
    self.init()
    notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.delegate = self
    notificationCenter.requestAuthorization(options: [.sound, .badge, .alert], completionHandler: notificationCenterAuthorized)
    self.locationManager = locationManager
  }
  
  func notificationCenterAuthorized(_ status: Bool, _ error: Error?) {
    if status == true {
      
      notificationCenter.getPendingNotificationRequests { requests in
        guard requests.count == 0 else {
          return
        }
        DispatchQueue.main.async {
          self.setupNotification()
        }
      }
      
    }
  }
  
  func setupNotification() {
    
    let content = UNMutableNotificationContent()
    content.title = "You're in the area"
    content.body = "Yay!"
    content.sound = UNNotificationSound.default()
    
    let trigger = UNLocationNotificationTrigger(region: locationManager.region, repeats: true)
    
    // Create the request object.
    let request = UNNotificationRequest(identifier: "Alert", content: content, trigger: trigger)
    notificationCenter.add(request, withCompletionHandler: { error in
      if let error = error {
        print("ERror with notification \(error)")
      } else {
        print("scehduled notification")
      }
    })
  }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
  
}
