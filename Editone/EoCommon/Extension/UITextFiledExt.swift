//
//  UITextFiledExt.swift
//
//

import Foundation
import UIKit

extension UITextField {
    func setPlaceholder(_ text: String, font: UIFont, color: UIColor) {
        let attributes = [
            NSAttributedString.Key.foregroundColor: color,
            NSAttributedString.Key.font: font
        ]
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
    }
}

extension UITextField {
    
    @IBInspectable var placeholderColor: UIColor? {
        get {
            return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor
        }
        set {
            guard let placeholderText = placeholder, let color = newValue else {
                return
            }
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        if let placeholderColor = placeholderColor {
            let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: placeholderColor]
            attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: attributes)
        }
    }
}
