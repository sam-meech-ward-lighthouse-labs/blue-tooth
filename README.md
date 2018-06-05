# Bluetooth

* Use it to connect devices together.
* Transfer data: anything from a simple command to streaming entire songs.
* 2.4 ghz like wifi

* Classical and BLE
  - Classical: 
    - Streamed music
    - transfer a lot of data
    - around 100 mbps
  - BLE: Bluetooth Low Energy
    - 0.3 mbps
    - Low powered hardware


## BLE Bluetooth Low Energy

* Central & Peripheral
  - Central can be anything, but usually a high powered device
  - Peripheral is the low powered device, usually a sensor or an ibeacon.
* Advertising Mode & Connected Mode
  - connected mode is a 1 to 1 relationship
  - advertising mode is 1 to many (iBeacons use that)

* Connected mode
  - Services
    - Characteristics


## iBeacon

* low powered piece of hardware that needs to communicate small amounts data.
* To help show user's their location / proximity

## Raspberry Pi



## iOS

* `ExternalAccessory` classical bluetooth
* `CoreBluetooth` BLE not related to iBeacons
* `CoreLocation` when using iBeacons

---

## Links

* https://learn.adafruit.com/introduction-to-bluetooth-low-energy/introduction\
* https://developer.apple.com/library/content/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral/BestPracticesForSettingUpYourIOSDeviceAsAPeripheral.html
* https://www.ntia.doc.gov/files/ntia/publications/2003-allochrt.pdf
* https://developer.apple.com/ibeacon/Getting-Started-with-iBeacon.pdf
* https://www.hackingwithswift.com/example-code/location/how-to-detect-ibeacons
* https://codeburst.io/getting-started-with-bluetooth-low-energy-on-ios-ada3090fc9cc

---

## Snippets

### Core Location

```swift
func setupLocationManager() {
  locationManager = CLLocationManager()
  locationManager.delegate = self
  locationManager.requestAlwaysAuthorization()
}
```

```swift
func setupBeacon() {
  let uuid = UUID(uuidString: "C383E0DD-644D-473B-B280-DCD260484EA0")!
  beacon = CLBeaconRegion(proximityUUID: uuid, identifier: "My_Beacon")
}
```

```swift
private func startScanning() {
  locationManager.startMonitoring(for: beacon)
  locationManager.startRangingBeacons(in: beacon)
}
```

```swift
func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
  if status == .authorizedAlways {
    if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
      if CLLocationManager.isRangingAvailable() {
        startScanning()
      }
    }
  }
}
```

```swift
func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
  print("proximity \(beacon.proximity), major \(beacon.major), minor \(beacon.minor)")
}
```

## User Notifications

```swift
func setupNotificationCenter() {
  notificationCenter = UNUserNotificationCenter.current()
  notificationCenter.delegate = self
  notificationCenter.requestAuthorization(options: [.sound, .badge, .alert], completionHandler: notificationCenterAuthorized)
}
```

```swift
func setupNotification(region: CLRegion) {
  let content = UNMutableNotificationContent()
  content.title = "You're in the area"
  content.body = "Yay!"
  content.sound = UNNotificationSound.default()
  
  let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
  
  // Create the request object.
  let request = UNNotificationRequest(identifier: "Alert", content: content, trigger: trigger)
  notificationCenter.add(request, withCompletionHandler: { error in
    if let error = error {
      print("ERror with notification \(error)")
    } else {
      print("scehduled notification")
    }
  })
}
```

### Peripheral

```swift
peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
```

```swift
func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
  guard peripheral.state == .poweredOn else {
    print("Not powered on")
    return
  }
  
  setup(peripheral: peripheral)
}
```

```swift
private func setup(peripheral: CBPeripheralManager) {
  let service = CBMutableService(type: , primary: true)
  services.append(service)
  
  let readCharacteristic = CBMutableCharacteristic(type: , properties: .read, value: nil, permissions: .readable)
  
  service.characteristics = [readCharacteristic]
  
  peripheralManager.add(service)
  
  let serviceData: [String: Any] = [CBAdvertisementDataLocalNameKey: "My Service", CBAdvertisementDataServiceUUIDsKey: [CBUUID(string: "")]]
  
  peripheral.startAdvertising(serviceData)
}
```

```swift
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
  request.value = "".data(using: .utf8)!
  peripheral.respond(to: request, withResult: .success)
}
```

### Central

```swift
manager = CBCentralManager(delegate: self, queue: nil)
```

```swift
func centralManagerDidUpdateState(_ central: CBCentralManager) {
  guard central.state == .poweredOn else {
    print("Central State is \(central.state.rawValue)")
    return
  }
  
  scan(central)
  print("scanning")
}
```

```swift 
func scan(_ central: CBCentralManager) {
  central.scanForPeripherals(withServices: nil, options: nil)
}
```

```swift
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    
  print(peripheral.name ?? "No Name")
  print(peripheral.identifier)
  
}
```

```swift
func connect(peripheral: CBPeripheral) {
  peripheral.delegate = self
  manager.connect(peripheral, options: nil)
  peripherals.append(peripheral)
}
```

```swift
func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
  print("Connected: \(peripheral.name ?? "No Name")")
  peripheral.discoverServices(nil)
}

func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
  print("Disconnected: \(peripheral.name ?? "No Name")")
  scan(central)
}
```

```swift
extension Central: CBPeripheralDelegate {
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else {
      print("No services")
      return
    }
    
    for service in services {
      print("Service: \(service.uuid.uuidString)")
      
      if service.uuid.uuidString == "" {
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
      if characteristic.uuid.uuidString == "" {
        peripheral.readValue(for: characteristic)
      }
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if let value = characteristic.value {
      print("didUpdateValueFor \(String(data: value, encoding: .utf8) ?? "No Value")")
    }
  }
}
```

### Cuppy