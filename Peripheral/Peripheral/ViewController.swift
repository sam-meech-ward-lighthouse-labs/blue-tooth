//
//  ViewController.swift
//  Peripheral
//
//  Created by Sam Meech-Ward on 2018-06-03.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  var peripheral: Peripheral!
  
  @IBOutlet weak var textfield: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    peripheral = Peripheral()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func submit(_ sender: Any) {
    peripheral.sendToSubscribed(message: textfield.text!)
  }
  
}

