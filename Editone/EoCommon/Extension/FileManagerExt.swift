//
//  FileManagerExt.swift
//
//

import Foundation

extension FileManager {
    
    func sizeOfFolder(atPath path: String) -> UInt64 {
        var size: UInt64 = 0
        if let subpaths = self.subpaths(atPath: path) {
            for file in subpaths {
                let filePath = path.appending("/").appending(file)
                do {
                    let attributes = try self.attributesOfItem(atPath: filePath)
                    if let fileSize = attributes[FileAttributeKey.size] as? UInt64 {
                        size += fileSize
                    }
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        return size
    }
    
    func getCacheSize() -> String {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        let cacheSize = FileManager.default.sizeOfFolder(atPath: cachePath)
        let formattedSize = ByteCountFormatter.string(fromByteCount: Int64(cacheSize), countStyle: .decimal)
        return formattedSize
    }
    
    func clearCache() {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]
        do {
            try FileManager.default.removeItem(atPath: cachePath)
            print("缓存已清除")
        } catch {
            print("Error: \(error)")
        }
    }
}
