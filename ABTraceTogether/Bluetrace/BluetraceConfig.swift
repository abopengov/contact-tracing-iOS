//
//  BluetraceConfig.swift
//  OpenTrace

import CoreBluetooth

import Foundation

struct BluetraceConfig {
 
    static let BluetoothServiceID = CBUUID(string: "B82AB3FC-1595-4F6A-80F0-FE094CC218F9")
    static let CharacteristicServiceIDv2 = CBUUID(string: "117BDD58-57CE-4E7A-8E87-7CCCDDA2A804")
    static let charUUIDArray = [CharacteristicServiceIDv2]

    static let OrgID = "CA_CA"
    static let ProtocolVersion = 2

    static let CentralScanInterval = 60.0 // in seconds
    static let CentralScanDuration = 10 // in seconds
    static let ScreenWakeNotificationInterval = 300.0// in seconds
    
    static let TTLDays = -21
}
