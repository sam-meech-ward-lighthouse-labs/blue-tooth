//
//  Central.swift
//  Bluetooth-Mac
//
//  Created by Sam Meech-Ward on 2018-06-03.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import Foundation
import CoreBluetooth

class Central: NSObject {
  var manager: CBCentralManager!
  var peripherals: [CBPeripheral] = []
  var writeCharacteristic: CBCharacteristic?
  
  override init() {
    super.init()
    manager = CBCentralManager(delegate: self, queue: nil)
  }
}

extension Central: CBCentralManagerDelegate {
  
  func scan(_ central: CBCentralManager) {
    central.scanForPeripherals(withServices: nil, options: nil)
  }
  
  func connect(peripheral: CBPeripheral) {
    peripheral.delegate = self
    manager.connect(peripheral, options: nil)
    peripherals.append(peripheral)
  }
  
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    guard central.state == .poweredOn else {
      print("Central State is \(central.state.rawValue)")
      return
    }
    
    scan(central)
    print("scanning")
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    
    print(peripheral.name ?? "No Name")
    
    if peripheral.name?.contains("Jazzy") == true {
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
    scan(central)
  }
  
  func writeToCharacteristic(message: String) {
    guard let characteristic = writeCharacteristic, let data = message.data(using: .utf8) else {
      return
    }
    
    peripherals[0].writeValue(data, for: characteristic, type: .withoutResponse)
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
      
      if service.uuid.uuidString == "34AFCA2C-46CB-43A9-A03D-3580A3B48939" {
        peripheral.delegate = self
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
      if characteristic.uuid.uuidString == "80C8A0B4-CDA3-4E8A-90DB-E780726C6BB8" {
        peripheral.readValue(for: characteristic)
      }
      if characteristic.uuid.uuidString == "F5F985FE-CC9B-47FE-B568-F47880B7B83F" {
        peripheral.setNotifyValue(true, for: characteristic)
      }
      if characteristic.uuid.uuidString == "BAC9B673-2449-47A3-AED3-E7FAB9D021C4" {
        writeCharacteristic = characteristic
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
