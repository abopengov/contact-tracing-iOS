//
//  UILabelExtension.swift
//  OpenTrace
//
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

enum StringStyles {
    case h2
    case body
    case eyebrowText
    case stepText
}

extension UILabel {
    func setLabel(with text: String, using stringStyle: StringStyles) {
        self.textColor = UIColor(red: 0.098, green: 0.094, blue: 0.094, alpha: 1)
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
        self.textAlignment = .center
        
        switch stringStyle {
        case .h2:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 18)
            self.text = text.uppercased()
        case .body:
            self.font = UIFont(name: "HelveticaNeue", size: 14)
            self.text = text
        case .eyebrowText:
            self.font = UIFont(name: "HelveticaNeue-LightItalic", size: 10)
            self.text = text
        case .stepText:
            self.font = UIFont(name: "HelveticaNeue-Bold", size: 14)
            self.textColor = UIColor(red: 0.646, green: 0.646, blue: 0.646, alpha: 1)
            self.text = text.uppercased()
        
        }
    }
}

extension UILabel {
    func setCharacterSpacing(characterSpacing: CGFloat = 0.0) {
        guard let labelText = text else { return }
        let attributedString: NSMutableAttributedString
        if let labelAttributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        // Character spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSMakeRange(0, attributedString.length - 1))
        attributedText = attributedString
    }
}
