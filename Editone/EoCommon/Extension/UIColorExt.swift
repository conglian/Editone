//
//  UIColorExt.swift
//
//

import Foundation
import UIKit

extension UIColor {

    /// 16进制Int转颜色
    public convenience init(_ value: Int, alpha: CGFloat = 1.0) {

        let red = CGFloat(value >> 16 & 0xff)
        let green = CGFloat(value >> 8 & 0xff)
        let black = CGFloat(value & 0xff)

        let color = UIColor(red: red/255.0, green: green/255.0, blue: black/255.0, alpha: alpha)

        self.init(cgColor: color.cgColor)
    }

    /// 16进制字符串转颜色
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        assert(hexFormatted.count == 6, "Invalid hex")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
    
    /// 随机色
    class func randomColor() -> UIColor {
       return UIColor.init(red:CGFloat(arc4random_uniform(255))/CGFloat(255.0), green:CGFloat(arc4random_uniform(255))/CGFloat(255.0), blue:CGFloat(arc4random_uniform(255))/CGFloat(255.0) , alpha: 1)
    }
    
    /// 渐变色
    class func color(rect: CGRect,
                     colors: [UIColor?],
                     locations: [NSNumber]? = nil,
                     start: CGPoint? = nil,
                     end: CGPoint? = nil) -> CAGradientLayer? {
        let g = CAGradientLayer()
        g.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
        let c = colors.compactMap({$0})
        g.colors = c.map({ $0.cgColor })
        if let l = locations {
            g.locations = l
        }else{
            g.locations = [0, 1]
        }
        if let s = start {
            g.startPoint = s
        }else{
            g.startPoint = CGPoint(x: 0, y: 0)
        }
        if let e = end {
            g.endPoint = e
        }else{
            g.endPoint = CGPoint(x: 1, y: 0)
        }
        return g
    }
    
    /// 改变透明度
    func changeAlpha(alpha: CGFloat = 1) -> UIColor {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
}
