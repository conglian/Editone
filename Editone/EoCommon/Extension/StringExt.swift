//
//  String+Ext.swift
//
//

import Foundation
//import Alamofire

extension String {
    
    /// base 64 加密
    func base64EncodedString() -> String? {
        return self.data(using: String.Encoding.utf8)?.base64EncodedString()
    }
    
    /// base 64解密
    func base64DecodedString()-> String? {
        guard let data = NSData(base64Encoded: self, options: Data.Base64DecodingOptions.init(rawValue: 0)) else {
            return nil
        }
        return String.init(data: data as Data, encoding: .utf8)
    }
    
    /// 移除空白
    func removeWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    /// 翻转字符串
    func reverseString() -> String {
        guard self.count > 1 else {
            return self
        }
        
        var chars = self.utf8CString
        var low = 0
        var high = chars.count - 2
        while low < high {
            chars.swapAt(low, high)
            low += 1
            high -= 1
        }
        return String(cString: Array(chars))
    }
    
    /// 国际化
    func localized() -> String {
        return NSLocalizedString(self, comment: self)
    }
}

extension String {
//    func toAfJson() -> Parameters? {
//        guard let data = data(using: .utf8) else {
//            return nil
//        }
//        guard let json =  try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? Parameters else {
//            return nil
//        }
//        return json
//    }
}

//extension Parameters {
//    func toString() -> String?  {
//        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .fragmentsAllowed) else {
//            return nil
//        }
//        return String.init(data: data, encoding: .utf8)
//    }
//}

extension String {
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    func toFloat() -> Float? {
        return Float(self.replacingOccurrences(of: NumberFormatter().decimalSeparator ?? ".", with: "."))
    }
}
