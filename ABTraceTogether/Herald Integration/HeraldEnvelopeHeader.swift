import Foundation

struct HeraldEnvelopeHeader {
    let protocolAndVersion: UInt8
    let countryCode: UInt16
    let stateCode: UInt16

    var data: Data {
        var headerData = Data()
        headerData.append(protocolAndVersion)
        headerData.append(countryCode)
        headerData.append(stateCode)
        return headerData
    }
}
