//
//  ViewController.swift
//  IBeacon
//
//  Created by Sam Meech-Ward on 2018-06-04.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var locationManager: LocationManager!
  var notificationManager: NotificationManager!
  
  @IBOutlet weak var statusLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    locationManager = LocationManager()
    locationManager.delegate = self
    notificationManager = NotificationManager(locationManager: locationManager)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

extension ViewController: LocationManagerDelegate {
  func locationManager(_ manager: LocationManager, didUpdateStatus status: String) {
    statusLabel.text = status
  }
}

