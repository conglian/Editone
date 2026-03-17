//
//  RecorderFileHandler.swift
//  RecordProject
//
//

import Foundation

class RecorderFileHandler {
    
    let fileManager: FileManager = .default
    
    func fileUrl(fileName: String) -> URL? {
        fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first?.appendingPathComponent(fileName)
    }
    
    func removeFile(fileName: String) {
        do {
            guard
                let url = fileUrl(fileName: fileName),
                fileManager.fileExists(atPath: url.path)
            else {
                return
            }
            try FileManager.default.removeItem(at: url)
        } catch {
            print("ファイルの削除に失敗しました。", error)
        }
    }
    
    func copy(atUrl: URL, toUrl: URL) {
        do {
            // atUrlをtoUrlにファイルをコピー
            try FileManager.default.copyItem(at: atUrl, to: toUrl)
        } catch {
            print("ファイルのコピーに失敗しました", error)
        }
    }
}
