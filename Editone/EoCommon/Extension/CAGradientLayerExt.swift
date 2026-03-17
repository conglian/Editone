//
//  CAGradientLayer+Extension.swift
//
//

import UIKit
 
enum GradientType {
    case upToUnder
    case leftToRight
    case underToUp
    case rightToLeft
}

extension CAGradientLayer {
    
    convenience init(frame: CGRect, direction: GradientType, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        colors.forEach { color in
            self.colors?.append(color.cgColor)
        }
        switch direction {
        case .leftToRight:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 1, y: 0)
        case .rightToLeft:
            startPoint = CGPoint(x: 1, y: 0)
            endPoint = CGPoint(x: 0, y: 0)
        case .upToUnder:
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 0, y: 1)
        case .underToUp:
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 0, y: 0)
        }
    }

    func createGradientImage() -> UIImage? {
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
}
