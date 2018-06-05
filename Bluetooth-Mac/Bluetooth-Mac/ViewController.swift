//
//  ViewController.swift
//  Bluetooth-Mac
//
//  Created by Sam Meech-Ward on 2018-06-03.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
  
  var ble: Central?

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    guard let _ = ble else {
      self.ble = Central()
      return
    }
    
  }
  
  @IBAction func scan(_ sender: Any) {
    
    self.ble?.writeToCharacteristic(message: "Hello from here")
  }
  
  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }


}

