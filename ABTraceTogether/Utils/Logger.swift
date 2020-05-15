//
//  Logger.swift
//  OpenTrace

import Foundation
import IBMMobileFirstPlatformFoundation

class Logger {

    static func DLog(_ message: String, file: NSString = #file, line: Int = #line, functionName: String = #function) {
        #if DEBUG
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
        print("[\(formatter.string(from: Date()))][\(file.lastPathComponent):\(line)][\(functionName)]: \(message)")
        #endif
    }

    static func logError(with message: String) {
            let logger: OCLogger = OCLogger.getInstanceWithPackage("ABTraceTogether")
            logger.logErrorWithMessages(message: message, "Error")
            OCLogger.send()
    }
}
