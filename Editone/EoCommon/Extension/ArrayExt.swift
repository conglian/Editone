//
//  ArrayExt.swift
//
//

import Foundation

extension Array {
    
    func randomElement<T>(_ array: [T]) -> T? {
        return array.randomElement()
    }
    
    func getRandomElements(_ n: Int) -> [Element] {
        if n >= self.count {
            return self
        } else {
            var result: [Element] = []
            var tempArray = self // 创建数组的修改副本
            
            for _ in 0..<n {
                let randomIndex = Int.random(in: 0..<tempArray.count)
                let randomElement = tempArray[randomIndex]
                result.append(randomElement)
                tempArray.remove(at: randomIndex)
            }
            
            return result
        }
    }
    
    func take(_ n: Int) -> Array {
        if n >= count {
            return self
        } else {
            return Array(self[0..<n])
        }
    }
    
    func elements(fromIndex n: Int) -> Array {
        if n >= count {
            return []
        } else {
            return Array(self[n..<count])
        }
    }
    
    func copyAndExtend(withRepeatCount n: Int) -> Array {
        #if DEBUG
        var extendedArray = self
        for _ in 1..<n {
            extendedArray.append(contentsOf: self)
        }
        return extendedArray
        #else
        return self
        #endif
    }
}
