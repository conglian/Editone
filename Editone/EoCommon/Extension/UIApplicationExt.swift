//
//  UIApplicationExt.swift
//
//

import Foundation
import UIKit

extension UIApplication {
    
    public var currentKeyWindow: UIWindow? {
        // iOS 13+
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            // iOS 12 及以下
            return UIApplication.shared.keyWindow
        }
    }
}
