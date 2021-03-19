//
//  EncounterRecord.swift
//  OpenTrace

import Foundation

struct EncounterRecord: Encodable {
    var timestamp: Date?
    var msg: String?
    var modelC: String?
    private(set) var modelP: String?
    var rssi: Double?
    var txPower: Double?
    var org: String?
    var v: Int?

    mutating func update(msg: String) {
        self.msg = msg
    }

    mutating func update(modelP: String) {
        self.modelP = modelP
    }

    init(msg: String?, modelC: String?, modelP: String?, rssi: Double?, txPower: Double?, org: String?, v: Int?) {
        self.timestamp = Date()
        self.msg = msg
        self.modelC = modelC
        self.modelP = modelP
        self.rssi = rssi
        self.txPower = txPower
        self.org = org
        self.v = v
    }

    // This initializer is used when central discovered a peripheral, and need to record down the rssi and txpower, and have not yet connected with the peripheral to get the msg
    init(rssi: Double, txPower: Double?) {
        self.timestamp = Date()
        self.msg = nil
        self.modelC = DeviceInfo.getModel()
        self.modelP = nil
        self.rssi = rssi
        self.txPower = txPower
        self.org = nil
        self.v = nil
    }

    init(msg: String) {
        self.timestamp = Date()
        self.msg = msg
        self.modelC = nil
        self.modelP = nil
        self.rssi = nil
        self.txPower = nil
        self.org = nil
        self.v = nil
    }
}
