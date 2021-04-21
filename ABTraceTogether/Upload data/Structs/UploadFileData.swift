//
//  UploadFileData.swift
//  OpenTrace

import Foundation

struct UploadFileData: Encodable {
    var covidTestData: CovidTestData
    var token: String
    var records: [Encounter]
    var events: [Encounter]
}
