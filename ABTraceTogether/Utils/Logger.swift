import Foundation
import IBMMobileFirstPlatformFoundation

enum Logger {
    static func DLog(_ message: String, file: NSString = #file, line: Int = #line, functionName: String = #function) {
        #if DEBUG
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
        print("[\(formatter.string(from: Date()))][\(file.lastPathComponent):\(line)][\(functionName)]: \(message)")
        #endif
    }

    static func logError(with message: String) {
        // swiftlint:disable:next redundant_type_annotation
        let logger: OCLogger = OCLogger.getInstanceWithPackage("AbTraceTogether")
        logger.logErrorWithMessages(message: message, "Error")
        OCLogger.send()
    }
}
