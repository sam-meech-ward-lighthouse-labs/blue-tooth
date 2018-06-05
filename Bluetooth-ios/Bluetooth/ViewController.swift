//
//  ViewController.swift
//  Bluetooth
//
//  Created by Sam Meech-Ward on 2018-06-01.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  var ble: BluetoothGuy!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    ble = BluetoothGuy()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

