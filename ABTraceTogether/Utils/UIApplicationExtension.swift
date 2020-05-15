//
//  UIApplicationExtension.swift
//  OpenTrace
//
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
