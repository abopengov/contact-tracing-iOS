import Foundation
import Herald

struct BlueTracePayload {
    let tempId: String
    let modelC: String
    let txPower: UInt16
    let rssi: Int8

    static let header = HeraldEnvelopeHeader(
        protocolAndVersion: 0x91,
        countryCode: 124,
        stateCode: 48
    )

    var data: Data {
        var payloadData = Data()
        payloadData.append(BlueTracePayload.header.data)

        var innerData = Data()
        _ = innerData.append(tempId, StringLengthEncodingOption.UINT16)

        let extendedData = ConcreteExtendedDataV1()
        extendedData.addSection(code: 0x40, value: rssi)
        extendedData.addSection(code: 0x41, value: txPower)
        extendedData.addSection(code: 0x42, value: modelC)

        if let extendedDataPayload = extendedData.payload() {
            innerData.append(extendedDataPayload.data)
        }

        payloadData.append(UInt16(innerData.count))
        payloadData.append(innerData)

        return payloadData
    }

    static func parse(payloadData: PayloadData) -> BlueTracePayload? {
        if payloadData.subdata(in: 0..<5) == header.data {
            let tempIdLength = payloadData.data.uint16(7) ?? 0
            guard let decodedTempId = payloadData.data.string(7, StringLengthEncodingOption.UINT16)?.value else {
                return nil
            }

            var modelC = ""
            var rssi: Int8 = 0
            var txPower: UInt16 = 0
            let extendedData = ConcreteExtendedDataV1(PayloadData(payloadData.subdata(in: (9 + Int(tempIdLength))..<payloadData.count)))

            for section in extendedData.getSections() {
                switch section.code {
                case 0x40:
                    rssi = section.data.int8(0) ?? 0

                case 0x41:
                    txPower = section.data.uint16(0) ?? 0

                case 0x42:
                    modelC = String(decoding: section.data, as: UTF8.self)

                default:
                    break
                }
            }

            return BlueTracePayload(
                tempId: decodedTempId,
                modelC: modelC,
                txPower: txPower,
                rssi: rssi
            )
        }
        return nil
    }
}
