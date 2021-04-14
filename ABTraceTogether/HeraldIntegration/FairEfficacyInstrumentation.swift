import Foundation
import Herald
import UIKit

public class FairEfficacyInstrumentation {
    private static let TEST_EFFICACY_ENABLED = "TEST_EFFICACY_ENABLED"

    // Singleton
    public static let shared = FairEfficacyInstrumentation()

    // Internals
    public let fixedTempId: String = FairEfficacyInstrumentation.generatePayloadData().base64EncodedString()

    public let enabled: Bool = Bundle.main.object(forInfoDictionaryKey: FairEfficacyInstrumentation.TEST_EFFICACY_ENABLED) as? Bool ?? false

    init() {
        if enabled {
            let onboardingNavigator = OnboardingNavigator(navigationController: UINavigationController())
            onboardingNavigator.welcomeCompleted = true
            onboardingNavigator.howItWorksCompleted = true
            onboardingNavigator.privacyCompleted = true
            onboardingNavigator.phoneRegistrationCompleted = true
        }
    }

    func addEfficacyLogging(sensor: SensorArray) {
        if let payloadData = sensor.payloadData {
            let payloadDataFormatter = CustomPayloadDataFormatter()

            // Loggers
            sensor.add(delegate: ContactLog(filename: "contacts.csv", payloadDataFormatter: payloadDataFormatter))
            sensor.add(delegate: StatisticsLog(filename: "statistics.csv", payloadData: payloadData))
            sensor.add(delegate: DetectionLog(filename: "detection.csv", payloadData: payloadData, payloadDataFormatter: payloadDataFormatter))
            _ = BatteryLog(filename: "battery.csv")
            if BLESensorConfiguration.payloadDataUpdateTimeInterval != .never {
                sensor.add(delegate: EventTimeIntervalLog(filename: "statistics_didRead.csv", payloadData: payloadData, eventType: .read))
            }
            Logger.DLog("DEVICE (payloadPrefix=\(payloadData.shortName),description=\(SensorArray.deviceDescription))")
        } else {
            Logger.DLog("DEVICE (payloadPrefix=EMPTY,description=\(SensorArray.deviceDescription))")
        }
    }

    // MARK: - Device information and consistent payload

    private func deviceModel() -> String {
        var deviceInformation = utsname()
        uname(&deviceInformation)
        let mirror = Mirror(reflecting: deviceInformation.machine)
        return mirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }

    private static func deviceType() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }

    /// Generate unique and consistent device identifier for testing detection and tracking
    private static func generatePayloadData() -> PayloadData {
        let deviceType = FairEfficacyInstrumentation.deviceType()
        // Generate unique identifier based on phone name
        let text = deviceType + ":" + UIDevice.current.name + ":" + UIDevice.current.model + ":" + UIDevice.current.systemName + ":" + UIDevice.current.systemVersion
        var hash = UInt64(5381)
        let buf = [UInt8](text.utf8)
        for b in buf {
            hash = 127 * (hash & 0x00ffffffffffffff) + UInt64(b)
        }
        let value = Int32(hash.remainderReportingOverflow(dividingBy: UInt64(Int32.max)).partialValue)

        // Need 61 bytes
        let payloadData = PayloadData()

        for _ in 1...15 {
            payloadData.append(value)
        }
        payloadData.append(Int8(0))

        return payloadData
    }
}

public struct CustomPayloadDataFormatter: PayloadDataFormatter {
    public func shortFormat(_ payloadData: PayloadData) -> String {
        guard !payloadData.data.isEmpty else {
            return ""
        }
        guard payloadData.data.count > 10 else {
            return payloadData.data.base64EncodedString()
        }
        return String(payloadData.data.subdata(in: 10..<payloadData.data.count).base64EncodedString().prefix(6))
    }
}
