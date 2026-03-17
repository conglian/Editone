//
//  FocusBasicEnums.swift
//
//

import Foundation
import UIKit

extension UIColor {
    
    static var view_background: UIColor {
        return UIColor(named: "view_back") ?? UIColor(hexString: "#F3F5F6")
    }
    
    static var main: UIColor {
        return UIColor(named: "main_color") ?? UIColor(hexString: "#F84E60")
    }
    
    /// 分割线
    static var line_color: UIColor {
        return UIColor(named: "line_color") ?? UIColor(hexString: "#F0F0F0")
    }
    
    /// 主标题
    static var mainTitle: UIColor {
        return UIColor(named: "main_title") ?? UIColor(hexString: "#333333")
    }
    
    /// 主标题
    static var titleColor: UIColor {
        return UIColor(named: "TitleColor") ?? UIColor(hexString: "#26273C")
    }
    
    /// 背景
    static var bgroundColors: UIColor {
        return UIColor(named: "bgroundColors") ?? UIColor(hexString: "#0C0F14")
    }
    
    /// 背景
    static var tabbarbgroundColors: UIColor {
        return UIColor(named: "bgroundColors") ?? UIColor(hexString: "#181B20")
    }
    
    
}
