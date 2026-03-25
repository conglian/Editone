//
//  FRFont.swift
//
//

import Foundation
import UIKit

extension UIFont {
    
    enum RanyWeight {
        case medium
        case regular
        case bold
        
        var name: String {
            switch self {
            case .medium:
                return "Rany-Medium"
            case .regular:
                return "Rany-Medium"
            case .bold:
                return "Rany-Bold"
            }
        }
    }
    
    class func ranyFont(ofSize: CGFloat, weight: RanyWeight) -> UIFont {
        return UIFont(name: weight.name, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: .bold)
    }
    
}
