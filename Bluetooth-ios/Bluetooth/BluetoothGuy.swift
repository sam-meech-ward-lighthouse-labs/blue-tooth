//
//  BluetoothGuy.swift
//  Bluetooth
//
//  Created by Sam Meech-Ward on 2018-06-01.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import Foundation
import CoreBluetooth

class BluetoothGuy: NSObject {
  var manager: CBCentralManager!
  var peripherals: [CBPeripheral] = []
  
  override init() {
    super.init()
    manager = CBCentralManager(delegate: self, queue: nil)
  }
}

extension BluetoothGuy: CBCentralManagerDelegate {
  
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
      print(peripheral.identifier)
      print(advertisementData)
    
    if peripheral.name?.contains("Cool") == true {
      central.stopScan()
      connect(peripheral: peripheral)
    }
  
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    print("Connected: \(peripheral.name ?? "No Name")")
    peripheral.discoverServices(nil)
  }
  
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    scan(central)
  }
}

extension BluetoothGuy: CBPeripheralDelegate {
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else {
      print("No services")
      return
    }
    
    for service in services {
      print("Service: \(service.uuid.uuidString)")
      
      if service.uuid.uuidString == BluetoothConstants.serviceUUID {
        peripheral.discoverCharacteristics(nil, for: service)
      }
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    guard let characteristics = service.characteristics else {
      print("No characteristics")
      return
    }
    
    for characteristic in characteristics {
      print(characteristic.uuid.uuidString)
    }
  }
}
