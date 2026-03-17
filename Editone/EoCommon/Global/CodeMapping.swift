//
//  CodeMapping.swift
//

import Foundation

class CodeMapping {
    
    private static var codeMappDic: [Int: Int] = [
        545656 : 200,
        45661 : 1000,
    ]
    
    static func value(_ key: Int) -> Int {
        guard let value = codeMappDic[key] else {
            return key
        }
        return value
    }
}
