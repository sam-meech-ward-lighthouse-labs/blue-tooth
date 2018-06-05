//
//  BluetoothGuy.swift
//  Bluetooth
//
//  Created by Sam Meech-Ward on 2018-06-01.
//  Copyright © 2018 meech-ward. All rights reserved.
//

import Foundation
import CoreBluetooth

let serviceUUID = CBUUID(string: "34AFCA2C-46CB-43A9-A03D-3580A3B48939")
let readCharacteristicUUID = CBUUID(string: "80C8A0B4-CDA3-4E8A-90DB-E780726C6BB8")
let notifyCharacteristicUUID = CBUUID(string: "F5F985FE-CC9B-47FE-B568-F47880B7B83F")
let writeCharacteristicUUID = CBUUID(string: "BAC9B673-2449-47A3-AED3-E7FAB9D021C4")

class Peripheral: NSObject {
  
  private var peripheralManager: CBPeripheralManager!
  private var services: [CBMutableService] = []
  private var characteristics: [CBMutableCharacteristic] = []
  private var subscribedCharacteristic: CBMutableCharacteristic?
  private let data: Data = "Feelin Jazzy 🤗".data(using: .utf8)!
  
  override init() {
    super.init()
    peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
  }
  
  private func setup(peripheral: CBPeripheralManager) {
    let service = CBMutableService(type: serviceUUID, primary: true)
    services.append(service)
    
    let readCharacteristic = CBMutableCharacteristic(type: readCharacteristicUUID, properties: .read, value: nil, permissions: .readable)
    characteristics.append(readCharacteristic)
    
    let notifyCharacteristic = CBMutableCharacteristic(type: notifyCharacteristicUUID, properties: .notify, value: nil, permissions: .readable)
    subscribedCharacteristic = notifyCharacteristic
    characteristics.append(notifyCharacteristic)
    
    let writeCharacteristic = CBMutableCharacteristic(type: writeCharacteristicUUID, properties: .write, value: nil, permissions: .writeable)
    characteristics.append(writeCharacteristic)
    
    service.characteristics = characteristics
    
    peripheralManager.add(service)
    
    let serviceData: [String: Any] = [CBAdvertisementDataLocalNameKey: "Jazzy Service", CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "D53B616A-C94D-43A6-96E8-6A2D39307392")]]
    
    peripheral.startAdvertising(serviceData)
  }
  
  func sendToSubscribed(message: String) {
    guard let characteristic = subscribedCharacteristic, let data = message.data(using: .utf8) else {
      return
    }
    
    peripheralManager.updateValue(data, for: characteristic, onSubscribedCentrals: nil)
  }
}

extension Peripheral: CBPeripheralManagerDelegate {
  func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    guard peripheral.state == .poweredOn else {
      print("No powered on")
      return
    }
    
    setup(peripheral: peripheral)
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
    if let error = error {
      print ("Error adding service \(error)")
      return
    }
    
    print("added service \(service.uuid.uuidString)")
  }
  
  func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
    if let error = error {
      print ("Error advertising \(error)")
      return
    }
    
    print("Advertising")
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveRead request: CBATTRequest) {
    request.value = data
    peripheral.respond(to: request, withResult: .success)
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
//    subscribedCharacteristic = characteristic
  }
  
  func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
    if let data = requests.first?.value {
      print(String(data: data, encoding: .utf8) ?? "No Data")
    }
    peripheral.respond(to: requests.first!, withResult: .success)
  }
}
