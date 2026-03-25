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

// 歌单操作
class LibraryPlayListFileManager {
    
    static let shared = LibraryPlayListFileManager()
    private init() {}
    
    // MARK: - Library/playlist 目录 URL
    private var playlistDirectoryURL: URL {
        let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let playlistURL = libraryURL.appendingPathComponent("playlist")
        if !FileManager.default.fileExists(atPath: playlistURL.path) {
            try? FileManager.default.createDirectory(at: playlistURL,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
        }
        return playlistURL
    }
    
    // MARK: - 创建子目录（playlist下）
    @discardableResult
    func createSubdirectory(name: String) -> URL? {
        let dirURL = playlistDirectoryURL.appendingPathComponent(name)
        if !FileManager.default.fileExists(atPath: dirURL.path) {
            do {
                try FileManager.default.createDirectory(at: dirURL,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                print("创建目录失败: \(error)")
                return nil
            }
        }
        return dirURL
    }
    
    // MARK: - 删除子目录（playlist下）
    @discardableResult
    func deleteSubdirectory(name: String) -> Bool {
        let dirURL = playlistDirectoryURL.appendingPathComponent(name)
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: dirURL.path) else {
            print("目录不存在: \(dirURL.path)")
            return false
        }
        do {
            try fileManager.removeItem(at: dirURL)
            return true
        } catch {
            print("删除目录失败: \(error)")
            return false
        }
    }
    
    // MARK: - 保存文件到子目录
    @discardableResult
    func saveFile(toSubdirectory dirName: String, fileName: String, sourceURL: URL) -> URL? {
        guard let dirURL = createSubdirectory(name: dirName) else {
            return nil
        }
        let destURL = dirURL.appendingPathComponent(fileName)
        let fileManager = FileManager.default
        do {
            // 如果文件已存在，先删除
            if fileManager.fileExists(atPath: destURL.path) {
                try fileManager.removeItem(at: destURL)
            }
            try fileManager.copyItem(at: sourceURL, to: destURL)
            return destURL
        } catch {
            print("保存文件失败: \(error)")
            return nil
        }
    }
    
    // MARK: - 删除子目录下的文件
    @discardableResult
    func deleteFile(inSubdirectory dirName: String, fileName: String) -> Bool {
        let fileURL = playlistDirectoryURL.appendingPathComponent(dirName).appendingPathComponent(fileName)
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: fileURL.path) else {
            print("文件不存在: \(fileURL.path)")
            return false
        }
        do {
            try fileManager.removeItem(at: fileURL)
            return true
        } catch {
            print("删除文件失败: \(error)")
            return false
        }
    }
    
    // MARK: - 获取子目录下所有文件 URL
    func allFiles(inSubdirectory dirName: String) -> [URL] {
        let dirURL = playlistDirectoryURL.appendingPathComponent(dirName)
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: dirURL.path) else {
            print("子目录不存在: \(dirURL.path)")
            return []
        }
        do {
            let files = try fileManager.contentsOfDirectory(at: dirURL,
                                                            includingPropertiesForKeys: nil,
                                                            options: [.skipsHiddenFiles])
            return files
        } catch {
            print("获取子目录文件列表失败: \(error)")
            return []
        }
    }
    
    // MARK: - 检查子目录中是否包含指定文件
    func subdirectory(_ dirName: String, containsFile fileName: String) -> Bool {
        let fileURL = playlistDirectoryURL.appendingPathComponent(dirName).appendingPathComponent(fileName)
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: fileURL.path)
    }
    
    // MARK: - 获取 playlist 下的所有子目录，按创建时间倒序
    func allSubdirectoriesSortedByCreationDateDesc() -> [URL] {
        let fileManager = FileManager.default
        do {
            // 获取 playlist 下的所有内容
            let contents = try fileManager.contentsOfDirectory(at: playlistDirectoryURL,
                                                               includingPropertiesForKeys: [.creationDateKey],
                                                               options: [.skipsHiddenFiles])
            
            // 只保留目录
            let directories = contents.filter { url in
                var isDir: ObjCBool = false
                fileManager.fileExists(atPath: url.path, isDirectory: &isDir)
                return isDir.boolValue
            }
            
            // 按创建时间倒序排序
            let sortedDirectories = try directories.sorted { url1, url2 in
                let values1 = try url1.resourceValues(forKeys: [.creationDateKey])
                let values2 = try url2.resourceValues(forKeys: [.creationDateKey])
                // 默认日期不存在时放到最后
                let date1 = values1.creationDate ?? Date.distantPast
                let date2 = values2.creationDate ?? Date.distantPast
                return date1 > date2
            }
            
            return sortedDirectories
        } catch {
            print("获取子目录列表失败: \(error)")
            return []
        }
    }
}
