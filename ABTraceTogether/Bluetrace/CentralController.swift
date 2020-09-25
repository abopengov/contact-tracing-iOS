//
//  CentralController.swift
//  OpenTrace

import Foundation
import CoreData
import CoreBluetooth
import UIKit

struct CentralWriteDataV2: Codable {
    var mc: String // phone model of central
    var rs: Double // rssi
    var id: String // tempID
    var o: String // organisation
    var v: Int // protocol version
}

class CentralController: NSObject {
    enum CentralError: Error {
        case centralAlreadyOn
        case centralAlreadyOff
    }
    var centralDidUpdateStateCallback: ((CBManagerState) -> Void)?
    var characteristicDidReadValue: ((EncounterRecord) -> Void)?
    var scanStartTime = 0.0
    private let restoreIdentifierKey = "com.opentrace.central"
    private var central: CBCentralManager?
    private var recoveredPeripherals: [CBPeripheral] = []
    private var queue: DispatchQueue
    var scanningTimer: Timer?
    
    
    // This dict keeps track of discovered android devices, so that we do not connect to the same Android device multiple times within the same BluetraceConfig.CentralScanInterval. Our Android code sets a Manufacturer field for this purpose.
    private var discoveredAndroidPeriManufacturerToUUIDMap = [Data: UUID]()
    
    // This dict has 2 purposes:
    // 1. Stores all the EncounterRecords, because the RSSI and TxPower is obtained at the didDiscoverPeripheral delegate, but characterstic value is obtained at didUpdateValueForCharacteristic delegate
    // 2. Used to check for duplicated iphones peripheral being discovered, so that we dont connect to the same iphone again in the same scan window
    private var scannedPeripherals = [UUID: (peripheral: CBPeripheral, encounter: EncounterRecord)]() // stores the peripherals encountered within one scan interval
    var timerForScanning: Timer?
    
    public init(queue: DispatchQueue) {
        self.queue = queue
        super.init()
    }
    
    func turnOn() {
        Logger.DLog("CC requested to be turnOn")
        guard central == nil else {
            return
        }
        let options: [String: Any] = [CBCentralManagerOptionRestoreIdentifierKey: restoreIdentifierKey,
                                      CBCentralManagerOptionShowPowerAlertKey: NSNumber(true)]
        central = CBCentralManager(delegate: self, queue: self.queue, options: options )
    }
    
    func turnOff() {
        Logger.DLog("CC turnOff")
        guard central != nil else {
            return
        }
        central?.stopScan()
        central = nil
    }
    
    func shouldRecordEncounter(_ encounter: EncounterRecord) -> Bool {
        guard let scannedDate = encounter.timestamp else {
            return true
        }
        if abs(scannedDate.timeIntervalSinceNow) > BluetraceConfig.CentralScanInterval {
            return true
        }
        return false
    }
    
    func shouldReconnectToPeripheral(peripheral: CBPeripheral) -> Bool {
        guard let encounteredPeripheral = scannedPeripherals[peripheral.identifier] else {
            return true
        }
        guard let scannedDate = encounteredPeripheral.encounter.timestamp else {
            return true
        }
        if abs(scannedDate.timeIntervalSinceNow) > BluetraceConfig.CentralScanInterval {
            return true
        }
        return false
    }
    
    public func getState() -> CBManagerState? {
        return central?.state
    }
    
}

extension CentralController: CBCentralManagerDelegate {
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
        Logger.DLog("CC willRestoreState. Central state: \(BluetraceUtils.managerStateToString(central.state))")
        if let peripheralsObject = dict[CBCentralManagerRestoredStatePeripheralsKey] {
            let peripherals = peripheralsObject as! Array<CBPeripheral>
            Logger.DLog("CC restoring \(peripherals.count) peripherals from system.")
            for peripheral in peripherals {
                recoveredPeripherals.append(peripheral)
                peripheral.delegate = self
            }
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        centralDidUpdateStateCallback?(central.state)
        switch central.state {
        case .poweredOn:
            Logger.DLog("CC Starting a scan")
            Encounter.saveWithCurrentTime(for: .scanningStarted)
            
            // for all peripherals that are not disconnected, disconnect them
            self.scannedPeripherals.forEach { (scannedPeri) in
                central.cancelPeripheralConnection(scannedPeri.value.peripheral)
            }
            // clear all peripherals, such that a new scan window can take place
            self.scannedPeripherals = [UUID: (CBPeripheral, EncounterRecord)]()
            self.discoveredAndroidPeriManufacturerToUUIDMap = [Data: UUID]()
            // handle a state restoration scenario
            for recoveredPeripheral in recoveredPeripherals {
                var restoredEncounter = EncounterRecord(rssi: 0, txPower: nil)
                restoredEncounter.timestamp = nil
                scannedPeripherals.updateValue((recoveredPeripheral, restoredEncounter),
                                               forKey: recoveredPeripheral.identifier)
                central.connect(recoveredPeripheral)
            }
            
            central.scanForPeripherals(withServices: [BluetraceConfig.BluetoothServiceID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(true)])
        default:
            Logger.DLog("State changed to \(central.state)")
        }
    }
    
    func sendNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        let content = UNMutableNotificationContent()
        content.title = "Advertiser Scanning"
        content.body = ""
        content.categoryIdentifier = "low-priority"
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        center.add(request)
    }
    
    func handlePeripheralOfUncertainStatus(_ peripheral: CBPeripheral) {
        // If not connected to Peripheral, attempt connection and exit
        if peripheral.state != .connected {
            Logger.DLog("CC handlePeripheralOfUncertainStatus not connected")
            central?.connect(peripheral)
            return
        }
        // If don't know about Peripheral's services, discover services and exit
        if peripheral.services == nil {
            Logger.DLog("CC handlePeripheralOfUncertainStatus unknown services")
            peripheral.discoverServices([BluetraceConfig.BluetoothServiceID])
            return
        }
        // If Peripheral's services don't contain targetID, disconnect and remove, then exit.
        // If it does contain targetID, discover characteristics for service
        guard let service = peripheral.services?.first(where: { $0.uuid == BluetraceConfig.BluetoothServiceID }) else {
            Logger.DLog("CC handlePeripheralOfUncertainStatus no matching Services")
            central?.cancelPeripheralConnection(peripheral)
            return
        }
        Logger.DLog("CC handlePeripheralOfUncertainStatus discoverCharacteristics")
        peripheral.discoverCharacteristics([BluetraceConfig.BluetoothServiceID], for: service)
        // If Peripheral's service's characteristics don't contain targetID, disconnect and remove, then exit.
        // If it does contain targetID, read value for characteristic
        guard let characteristic = service.characteristics?.first(where: { $0.uuid == BluetraceConfig.BluetoothServiceID}) else {
            Logger.DLog("CC handlePeripheralOfUncertainStatus no matching Characteristics")
            central?.cancelPeripheralConnection(peripheral)
            return
        }
        Logger.DLog("CC handlePeripheralOfUncertainStatus readValue")
        peripheral.readValue(for: characteristic)
        return
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        let debugLogs = ["CentralState": BluetraceUtils.managerStateToString(central.state),
                         "peripheral": peripheral,
                         "advertisments": advertisementData as AnyObject] as AnyObject
        
        Logger.DLog("\(debugLogs)")
        var initialEncounter = EncounterRecord(rssi: RSSI.doubleValue, txPower: advertisementData[CBAdvertisementDataTxPowerLevelKey] as? Double)
        initialEncounter.timestamp = nil
        
        // iphones will "mask" the peripheral's identifier for android devices, resulting in the same android device being discovered multiple times with different peripheral identifier. Hence android is using CBAdvertisementDataServiceDataKey data for identifying an android pheripheral
        
        // Also, check that the length is greater than 2 to prevent crash. Otherwise ignore.
        if let manuData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data, manuData.count > 2 {
            let androidIdentifierData = manuData.subdata(in: 2..<manuData.count)
            if discoveredAndroidPeriManufacturerToUUIDMap.keys.contains(androidIdentifierData) {
                Logger.DLog("Android Peripheral \(peripheral) has been discovered already in this window, will not attempt to connect to it again")
                return
            } else {
                peripheral.delegate = self
                discoveredAndroidPeriManufacturerToUUIDMap.updateValue(peripheral.identifier, forKey: androidIdentifierData)
                scannedPeripherals.updateValue((peripheral, initialEncounter), forKey: peripheral.identifier)
                central.connect(peripheral)
            }
        } else {
            // Means this is not an android device. We check if the peripheral.identifier exist in the scannedPeripherals
            Logger.DLog("CBAdvertisementDataManufacturerDataKey Data not found. Peripheral is likely not android")
            if let encounteredPeripheral = scannedPeripherals[peripheral.identifier] {
                if shouldReconnectToPeripheral(peripheral: encounteredPeripheral.peripheral) {
                    peripheral.delegate = self
                    if peripheral.state != .connected {
                        central.connect(peripheral)
                        Logger.DLog("found previous peripheral from more than 60 seconds ago")
                    }
                } else {
                    Logger.DLog("iOS Peripheral \(peripheral) has been discovered already in this window, will not attempt to connect to it again")
                    if let scannedDate = encounteredPeripheral.encounter.timestamp {
                        Logger.DLog("It was found \(scannedDate.timeIntervalSinceNow) seconds ago")
                    }
                }
            } else {
                peripheral.delegate = self
                scannedPeripherals.updateValue((peripheral, initialEncounter), forKey: peripheral.identifier)
                central.connect(peripheral)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let peripheralStateString = BluetraceUtils.peripheralStateToString(peripheral.state)
        Logger.DLog("CC didConnect peripheral peripheralCentral state: \(BluetraceUtils.managerStateToString(central.state)), Peripheral state: \(peripheralStateString)")
        guard shouldReconnectToPeripheral(peripheral: peripheral) else {
            central.cancelPeripheralConnection(peripheral)
            return
        }
        peripheral.delegate = self
        peripheral.readRSSI()
        peripheral.discoverServices([BluetraceConfig.BluetoothServiceID])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        Logger.DLog("CC didDisconnectPeripheral \(peripheral) , \(error != nil ? "error: \(error.debugDescription)" : "" )")
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        Logger.DLog("CC didFailToConnect peripheral \(error != nil ? "error: \(error.debugDescription)" : "" )")
    }
}

extension CentralController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let err = error {
            Logger.DLog("error: \(err)")
        }
        if error == nil {
            if let existingPeripheral = scannedPeripherals[peripheral.identifier] {
                var scannedEncounter = existingPeripheral.encounter
                scannedEncounter.rssi = RSSI.doubleValue
                scannedPeripherals.updateValue((existingPeripheral.peripheral, scannedEncounter), forKey: peripheral.identifier)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        Logger.DLog("Peripheral: \(peripheral) didModifyServices: \(invalidatedServices)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let err = error {
            Logger.DLog("error: \(err)")
        }
        guard let service = peripheral.services?.first(where: { $0.uuid == BluetraceConfig.BluetoothServiceID }) else { return }
        
        peripheral.discoverCharacteristics([BluetraceConfig.CharacteristicServiceIDv2], for: service)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let err = error {
            Logger.DLog("error: \(err)")
        }
        
        guard let characteristic = service.characteristics?.first(where: { $0.uuid == BluetraceConfig.CharacteristicServiceIDv2}) else { return }
        
        peripheral.readValue(for: characteristic)
        
        // Do not need to wait for a successful read before writing, because no data from the read is needed in the write
        if let currEncounter = scannedPeripherals[peripheral.identifier] {
            EncounterMessageManager.shared.getTempId { (result) in
                guard let tempId = result else {
                    Logger.DLog("broadcast msg not present")
                    return
                }
                guard let rssi = currEncounter.encounter.rssi else {
                    Logger.DLog("rssi should be present in \(currEncounter.encounter)")
                    return
                }
                let bluetraceImplementation = Bluetrace.getImplementation(characteristic.uuid.uuidString)
                
                guard let encodedData = bluetraceImplementation.central.prepareWriteRequestData(tempId: tempId, rssi: rssi, txPower: currEncounter.encounter.txPower) else {
                    return
                }
                peripheral.writeValue(encodedData, for: characteristic, type: .withResponse)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let debugLogs = ["characteristic": characteristic as AnyObject,
                         "encounter": scannedPeripherals[peripheral.identifier] as AnyObject] as AnyObject
        
        Logger.DLog("\(debugLogs)")
        guard error == nil else {
            Logger.DLog("Error: \(String(describing: error))")
            return
        }
        
        if let scannedPeri = scannedPeripherals[peripheral.identifier],
            let characteristicValue = characteristic.value,
            shouldRecordEncounter(scannedPeri.encounter) {
            do {
                let peripheralCharData = try JSONDecoder().decode(PeripheralCharacteristicsDataV2.self, from: characteristicValue)
                var encounterStruct = scannedPeri.encounter
                encounterStruct.msg = peripheralCharData.id
                encounterStruct.update(modelP: peripheralCharData.mp)
                encounterStruct.org = peripheralCharData.o
                encounterStruct.v = peripheralCharData.v
                encounterStruct.timestamp = Date()
                scannedPeripherals.updateValue((scannedPeri.peripheral, encounterStruct), forKey: peripheral.identifier)
                encounterStruct.saveToCoreData()
                Logger.DLog("Central recorded encounter with \(String(describing: scannedPeri.peripheral.name))")
            } catch {
                Logger.DLog("Error: \(error). CharacteristicValue is \(characteristicValue)")
            }
        } else {
            Logger.DLog("Error: scannedPeripherals[peripheral.identifier] is \(String(describing: scannedPeripherals[peripheral.identifier])), characteristic.value is \(String(describing: characteristic.value))")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        Logger.DLog("didWriteValueFor to peripheral: \(peripheral), for characteristics: \(characteristic). \(error != nil ? "error: \(error.debugDescription)" : "" )")
        central?.cancelPeripheralConnection(peripheral)
    }
}

