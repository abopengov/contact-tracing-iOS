//
//  MainTabBarController.swift
//  OpenTrace
//
//  Created by Marquise Kamanke on 2020-04-22.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

class MainTabBarController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let items = tabBar.items {
            // Setting the title text color of all tab bar items:
            for item in items {
                item.setTitleTextAttributes([.foregroundColor: UIColor(red: 0.329, green: 0.784, blue: 0.91, alpha: 1)], for: .selected)
                item.setTitleTextAttributes([.foregroundColor: UIColor(red: 0.325, green: 0.157, blue: 0.31, alpha: 1)], for: .normal)
            }
        }
    }
}
