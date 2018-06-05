//
//  Central.swift
//  Bluetooth-Mac
//
//  Created by Sam Meech-Ward on 2018-06-03.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import Foundation
import CoreBluetooth

typealias ConnectedCallback = (Error?) -> (Void)

class Central: NSObject {
  
  private var centralManager: CBCentralManager!
  private var peripheral: CBPeripheral?
  private var writeCharacteristic: CBCharacteristic?
  
  private var connectedCallback: ConnectedCallback?
  
  override init() {
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: nil)
  }
  
  func connect(callback: ConnectedCallback?) {
    guard centralManager.state == .poweredOn else {
      print("Cant start scanning")
      return
    }
    connectedCallback = callback
    centralManager.scanForPeripherals(withServices: nil, options: nil)
  }
  
  func sendMessage(message: String) {
    guard let characteristic = writeCharacteristic, let peripheral = peripheral, let data = message.data(using: .utf8) else {
      return
    }
    
    peripheral.writeValue(data, for: characteristic, type: .withoutResponse)
  }
  
  private func connect(peripheral: CBPeripheral) {
    peripheral.delegate = self
    centralManager.connect(peripheral, options: nil)
    self.peripheral = peripheral
  }
  
}

extension Central: CBCentralManagerDelegate {
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    guard central.state == .poweredOn else {
      print("Central State is \(central.state.rawValue)")
      return
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    
    print(peripheral.name ?? "No Name")
    
    if peripheral.identifier.uuidString == "325A750F-94F6-8EA0-7A3C-D2C75E560CBA" {
      central.stopScan()
      print(peripheral.identifier)
      print(advertisementData)
      connect(peripheral: peripheral)
    }
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("Connected: \(peripheral.name ?? "No Name")")
    peripheral.discoverServices(nil)
  }
  
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    print("Disconnected: \(peripheral.name ?? "No Name")")
    connect(callback: nil)
  }
  
}

extension Central: CBPeripheralDelegate {
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else {
      print("No services")
      return
    }
    
    for service in services {
      print("Service: \(service.uuid.uuidString)")
      
      if service.uuid.uuidString == "A7229812-D372-495B-B51D-B54C408A3659" {
        peripheral.discoverCharacteristics(nil, for: service)
      }
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    guard let characteristics = service.characteristics else {
      print("No Characteristics")
      return
    }
    
    for characteristic in characteristics {
      print("Characteristic: \(characteristic.uuid.uuidString)")
      if characteristic.uuid.uuidString == "2D49A86E-02D8-46A9-84E8-636488225FF5" {
        writeCharacteristic = characteristic
        connectedCallback?(nil)
      }
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if let error = error {
      print ("Error didUpdateValueFor \(error)")
      return
    }
    
    if let value = characteristic.value {
      print("didUpdateValueFor \(String(data: value, encoding: .utf8) ?? "No Value")")
    }
    
  }
}
