//
//  ViewController.swift
//  CentralCuppy
//
//  Created by Sam Meech-Ward on 2018-06-03.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import UIKit

fileprivate enum CuppyState {
  case started
  case stopped
}

class ViewController: UIViewController {

  let central = Central()
  
  @IBOutlet weak var statusLabel: UILabel!
  
  fileprivate var state = CuppyState.stopped
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func Connect(_ sender: Any) {
    central.connect { _ in
      self.statusLabel.text = "connected"
    }
  }
  
  @IBAction func start(_ sender: UIButton) {
    switch state {
    case .started:
      central.sendMessage(message: "stop")
      sender.setTitle("Stopped", for: .normal)
      state = .stopped
    case .stopped:
      central.sendMessage(message: "start")
      sender.setTitle("Started", for: .normal)
      state = .started
    }
  }
}

