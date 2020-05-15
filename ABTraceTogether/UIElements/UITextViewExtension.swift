//
//  UITextViewExtension.swift
//  ABTraceTogether_AdHoc
//
//  Created by Marquise Kamanke on 2020-04-27.
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

extension UITextView {
    func setAttributedEmailLink(with startText: String, and linkText: String, and linkurl: String, and middleText: String, and firstEmailLink: String, and endText: String, and secondEmailLink: String) {
        let attributedEmailString = NSMutableAttributedString(string: firstEmailLink)
        attributedEmailString.addAttribute(.link, value: "mailto:" + firstEmailLink, range: NSRange(location: 0, length: firstEmailLink.count))
        
        let linkString = NSMutableAttributedString(string: linkText)
        linkString.addAttribute(.link, value: linkurl, range: NSRange(location: 0, length: linkText.count))
        
        let attributedEmailStringTwo = NSMutableAttributedString(string: secondEmailLink)
        attributedEmailStringTwo.addAttribute(.link, value: "mailto:" + secondEmailLink, range: NSRange(location: 0, length: secondEmailLink.count))

        let fullAttributedString = NSMutableAttributedString(string: startText)
        fullAttributedString.append(linkString)
        fullAttributedString.append(NSMutableAttributedString(string: middleText))
        fullAttributedString.append(attributedEmailString)
        fullAttributedString.append(NSMutableAttributedString(string: endText))
        fullAttributedString.append(attributedEmailStringTwo)
        
        self.textColor = UIColor(red: 0.098, green: 0.094, blue: 0.094, alpha: 1)
        self.textAlignment = .left
        self.attributedText = fullAttributedString
        self.font = UIFont(name: "HelveticaNeue", size: 14)
    }
}
