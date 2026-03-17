//
//  FRFont.swift
//
//

import Foundation
import UIKit

extension UIFont {
    
    enum BalooWeight {
        case bold
        case extra
        case medium
        case regular
        case semiBold
        
        var name: String {
            switch self {
            case .bold:
                return "Baloo2-Bold"
            case .extra:
                return "Baloo2-ExtraBold"
            case .medium:
                return "Baloo2-Medium"
            case .regular:
                return "Baloo2-Regular"
            case .semiBold:
                return "Baloo2-SemiBold"
            }
        }
    }
    
    enum PopinWeight {
        case black
        case medium
        case regular
        case bold
        
        var name: String {
            switch self {
            case .black:
                return "Poppins-Black"
            case .medium:
                return "Poppins-Medium"
            case .regular:
                return "Poppins-Regular"
            case .bold:
                return "Poppins-Bold"
            }
        }
    }
    
    class func balooFont(ofSize: CGFloat, weight: BalooWeight) -> UIFont {
        return UIFont(name: weight.name, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: .bold)
    }
    
    class func popinFont(ofSize: CGFloat, weight: PopinWeight) -> UIFont {
        return UIFont(name: weight.name, size: ofSize) ?? UIFont.systemFont(ofSize: ofSize, weight: .bold)
    }
    
}
