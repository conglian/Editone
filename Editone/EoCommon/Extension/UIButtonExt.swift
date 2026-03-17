//
//  UIButtonExt.swift
//
//

import Foundation
import UIKit

extension UIButton {
    func addUnderlineToText() {
        guard let buttonText = self.titleLabel?.text else {
            return
        }
        let attributedString = NSMutableAttributedString(string: buttonText)
        let range = NSRange(location: 0, length: buttonText.count)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
