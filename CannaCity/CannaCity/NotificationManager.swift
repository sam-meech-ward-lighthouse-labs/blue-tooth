//
//  NotificationManager.swift
//  CannaCity
//
//  Created by Sam Meech-Ward on 2018-06-05.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import Foundation
import UserNotifications
import CoreLocation

class NotificationManager: NSObject {
  var notificationCenter: UNUserNotificationCenter!
  var region: CLRegion!
  
  convenience init(region: CLRegion) {
    self.init()
    self.region = region
    setupNotificationCenter()
    
  }
  
  func setupNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Weed"
    content.body = "420 Blaze it!"
    content.sound = UNNotificationSound.default()
    
    let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
    
    // Create the request object.
    let request = UNNotificationRequest(identifier: "420-alert", content: content, trigger: trigger)
    notificationCenter.add(request, withCompletionHandler: { error in
      if let error = error {
        print("ERror with notification \(error)")
      } else {
        print("scehduled notification")
      }
    })
  }
  
  func setupNotificationCenter() {
    notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.delegate = self
    notificationCenter.requestAuthorization(options: [.sound, .badge, .alert]) { (success, error) in
      self.setupNotification()
    }
  }
}

extension NotificationManager: UNUserNotificationCenterDelegate {
  
}
