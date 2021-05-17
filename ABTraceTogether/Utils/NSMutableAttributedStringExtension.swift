import Foundation
import UIKit

public extension NSMutableAttributedString {
    func setAsLink(textToFind: String, linkURL: String) {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            guard let url = URL(string: linkURL) else {
                return
            }

            self.addAttribute(.attachment, value: url, range: foundRange)
            self.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: foundRange)
            self.addAttribute(.foregroundColor, value: UIColor(red: 0.00, green: 0.44, blue: 0.77, alpha: 1.00), range: foundRange)
        }
    }
}
