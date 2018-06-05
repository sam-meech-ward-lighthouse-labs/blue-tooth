//
//  ViewController.swift
//  CannaCity
//
//  Created by Sam Meech-Ward on 2018-06-05.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var locationManager: LocationManager!
  var notifactionManager: NotificationManager!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    locationManager = LocationManager()
    notifactionManager = NotificationManager(region: locationManager.beacon)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

