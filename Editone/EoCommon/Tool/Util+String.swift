//
//  Util+String.swift
//
//

import Foundation
import CommonCrypto
import UIKit

extension Util {

    class func encrypt(_ string: String, shiftBy: UInt32) -> String {
        let shiftedScalarValues = string.unicodeScalars.map { UnicodeScalar($0.value + shiftBy)! }
        return String(String.UnicodeScalarView(shiftedScalarValues))
    }

    class func decrypt(_ string: String, shiftBy: UInt32) -> String {
        let shiftedScalarValues = string.unicodeScalars.map { UnicodeScalar($0.value - shiftBy)! }
        return String(String.UnicodeScalarView(shiftedScalarValues))
    }
    
    // 加密方法：输入字典和密钥，输出加密后的字符串
    class func encrypt(_ dict: [String: Any], key: String) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: dict, options: [])
        let keyData = key.data(using: .utf8)!
        let keyBytes = [UInt8](keyData)
        
        // 设置 IV 向量，使用随机生成的 16 个字节
        var iv = [UInt8](repeating: 0, count: kCCBlockSizeAES128)
        let status = SecRandomCopyBytes(kSecRandomDefault, iv.count, &iv)
        guard status == errSecSuccess else {
            throw NSError(domain: "Encryption error", code: Int(status), userInfo: nil)
        }
        
        // 构造输入参数
        let inputData = [UInt8](data)
        var output = [UInt8](repeating: 0, count: inputData.count + kCCBlockSizeAES128)
        var outputByteCount = 0
        
        // 进行加密
        let cryptStatus = CCCrypt(CCOperation(kCCEncrypt),
                                  CCAlgorithm(kCCAlgorithmAES),
                                  CCOptions(kCCOptionPKCS7Padding),
                                  keyBytes, kCCKeySizeAES128,
                                  iv,
                                  inputData, inputData.count,
                                  &output, output.count,
                                  &outputByteCount)
        guard cryptStatus == kCCSuccess else {
            throw NSError(domain: "Encryption error", code: Int(cryptStatus), userInfo: nil)
        }
        let encryptedData = Data(output[..<outputByteCount])
        
        // 返回加密后的字符串，包括 IV 向量和加密后的数据
        let ivString = Data(iv).base64EncodedString()
        let encryptedString = encryptedData.base64EncodedString()
        return "\(ivString):\(encryptedString)"
    }

    // 解密方法：输入加密后的字符串和密钥，输出解密后的字典
    class func decrypt(_ encryptedString: String, key: String) throws -> [String: Any] {
        let components = encryptedString.components(separatedBy: ":")
        guard components.count == 2 else {
            throw NSError(domain: "Decryption error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid input string"])
        }
        let ivData = Data(base64Encoded: components[0])!
        let iv = [UInt8](ivData)
        let encryptedData = Data(base64Encoded: components[1])!
        let dataBytes = [UInt8](encryptedData)
        
        let keyData = key.data(using: .utf8)!
        let keyBytes = [UInt8](keyData)
        
        // 构造输入参数
        var decrypted = [UInt8](repeating: 0, count: dataBytes.count + kCCBlockSizeAES128)
        var decryptedByteCount = 0
        
        // 进行解密
        let cryptStatus = CCCrypt(CCOperation(kCCDecrypt),
                                  CCAlgorithm(kCCAlgorithmAES),
                                  CCOptions(kCCOptionPKCS7Padding),
                                  keyBytes, kCCKeySizeAES128,
                                  iv,
                                  dataBytes, dataBytes.count,
                                  &decrypted, decrypted.count,
                                  &decryptedByteCount)
        guard cryptStatus == kCCSuccess else {
            throw NSError(domain: "Encryption error", code: Int(cryptStatus), userInfo: nil)
        }
        let decryptedData = Data(decrypted[..<decryptedByteCount])
        
        // 将解密后的数据转换为字典
        guard let decryptedDict = try JSONSerialization.jsonObject(with: decryptedData, options: []) as? [String: Any] else {
            throw NSError(domain: "Decryption error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid decrypted data"])
        }
        
        return decryptedDict
    }
    
    /// 字符串反转并实现大小写替换
    class func reverseAndReplace(_ string: String) -> String {
        // 反转字符串
        let stringReversed = String(string.reversed())
        // 替换大小写
        var result = ""
        for char in stringReversed {
            if char.isUppercase {
                result += String(char.lowercased())
            } else if char.isLowercase {
                result += String(char.uppercased())
            } else {
                result += String(char)
            }
        }
        return result
    }
    
    
    /// 字典转字符串
    class func dictionaryToString(_ dictionary: [String: Any]) -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) else {
            return nil
        }
        return String(data: jsonData, encoding: .utf8)
    }
    
    /// 字符串转字典
    class func stringToDictionary(_ string: String) -> [String: Any]? {
        guard let jsonData = string.data(using: .utf8) else {
            return nil
        }
        guard let jsonDictionary = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
            return nil
        }
        return jsonDictionary
    }
    
    
    /// 移除头部尾部字符串
    /// - Parameters:
    ///   - str: 字符串
    ///   - n: 头部n
    ///   - m: 尾部m
    /// - Returns: 返回结果
    class func removePrefixSuffix(_ str: String, n: Int, m: Int) -> String {
        let startIndex = str.index(str.startIndex, offsetBy: n)
        let endIndex = str.index(str.endIndex, offsetBy: -m)

        return String(str[startIndex..<endIndex])
    }
    
    
    /// 计算文本宽高
    /// - Parameters:
    ///   - text: 文本
    ///   - font: 字体
    ///   - maxWidth: 最大宽度
    ///   - maxHeight: 最大高度
    /// - Returns: 尺寸
    class func calculateTextSize(text: String, font: UIFont, maxWidth: CGFloat, maxHeight: CGFloat) -> CGSize {
        
        let attributes = [NSAttributedString.Key.font: font]
                    
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
                    
        let rect : CGRect = text.boundingRect(with: CGSize(width: maxWidth, height: maxHeight), options: option,
                          attributes: attributes, context: nil)
        return rect.size
    }
}
