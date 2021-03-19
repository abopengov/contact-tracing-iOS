import Foundation
import IBMMobileFirstPlatformFoundation

extension OCLogger {
    // Log methods with no metadata
    func logTraceWithMessages(message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_TRACE, message: message, args: getVaList(args), userInfo: [String: String]())
    }
    func logDebugWithMessages(message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_DEBUG, message: message, args: getVaList(args), userInfo: [String: String]())
    }
    func logInfoWithMessages(message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_INFO, message: message, args: getVaList(args), userInfo: [String: String]())
    }
    func logWarnWithMessages(message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_WARN, message: message, args: getVaList(args), userInfo: [String: String]())
    }
    func logErrorWithMessages(message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_ERROR, message: message, args: getVaList(args), userInfo: [String: String]())
    }
    func logFatalWithMessages(message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_FATAL, message: message, args: getVaList(args), userInfo: [String: String]())
    }
    func logAnalyticsWithMessages(message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_ANALYTICS, message: message, args: getVaList(args), userInfo: [String: String]())
    }
    // Log methods with metadata
    func logTraceWithUserInfo(userInfo: [String: String], message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_TRACE, message: message, args: getVaList(args), userInfo: userInfo)
    }
    func logDebugWithUserInfo(userInfo: [String: String], message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_DEBUG, message: message, args: getVaList(args), userInfo: userInfo)
    }
    func logInfoWithUserInfo(userInfo: [String: String], message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_INFO, message: message, args: getVaList(args), userInfo: userInfo)
    }
    func logWarnWithUserInfo(userInfo: [String: String], message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_WARN, message: message, args: getVaList(args), userInfo: userInfo)
    }
    func logErrorWithUserInfo(userInfo: [String: String], message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_ERROR, message: message, args: getVaList(args), userInfo: userInfo)
    }
    func logFatalWithUserInfo(userInfo: [String: String], message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_FATAL, message: message, args: getVaList(args), userInfo: userInfo)
    }
    func logAnalyticsWithUserInfo(userInfo: [String: String], message: String, _ args: CVarArg...) {
        log(withLevel: OCLogger_ANALYTICS, message: message, args: getVaList(args), userInfo: userInfo)
    }
}
