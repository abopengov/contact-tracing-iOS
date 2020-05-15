//
//  UIButtonExtension.swift
//  OpenTrace
//
//  Copyright © 2020 OpenTrace. All rights reserved.
//

import UIKit

enum ButtonImage {
    case arrow
    case check
    
    var name: String {
        switch self {
        case .arrow: return "Arrow"
        case .check: return "Checkmark"
        }
    }
}

extension UIButton {
    
    func setButton(with text: String, and buttonImage: ButtonImage) {
        guard let font = UIFont(name: "HelveticaNeue-Bold", size: 18) else {
            return
        }
        
        if self.isEnabled {
                   self.backgroundColor = UIColor(red: 0, green: 0.439, blue: 0.769, alpha: 1)
               } else {
                   self.backgroundColor = UIColor(red: 0.646, green: 0.646, blue: 0.646, alpha: 1)
               }
       
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        let fullString = NSMutableAttributedString(string: text + "  ",
                                                   attributes: attributes)
        let image1Attachment = textAttachment(font: font, image: UIImage(named: buttonImage.name)!)
        let image1String = NSAttributedString(attachment: image1Attachment)
        
        fullString.append(image1String)
        self.setAttributedTitle(fullString, for: .normal)
        self.layoutIfNeeded()
    }
    
    private func textAttachment(font: UIFont, image: UIImage) -> NSTextAttachment {
        let font = font
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        let mid = font.descender + font.capHeight
        textAttachment.bounds = CGRect(x: 0, y: font.descender - image.size.height / 2 + mid + 2, width: image.size.width, height: image.size.height).integral
        return textAttachment
    }
}
