//
//  AudioManager.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 18/03/2026.
//

import UIKit
import AVFoundation

class AudioManager: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    static let share = AudioManager()
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    var recordingSession: AVAudioSession!
    var recordTimer: Timer?
    var playTimer: Timer?
    
    var currentRecordTime: TimeInterval = 0
    var currentPlayTime: TimeInterval = 0
    
    var lastRecordingURL: URL?
    
    var timeBlocks : (() -> Void)?
    
    var saveEndBlocks : ((URL) -> Void)?
    
    override init() {
        super.init()
        recordingSession = AVAudioSession.sharedInstance()
        try? recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
        try? recordingSession.setActive(true)
    }
    
    // MARK: - 开始录音
    func startRecording(fileNames: String) {
        let fileName = getDocumentsDirectory().appendingPathComponent("\(fileNames).m4a")
        lastRecordingURL = fileName
        
        // 如果文件存在，先删除
        if FileManager.default.fileExists(atPath: fileName.path) {
            try? FileManager.default.removeItem(at: fileName)
            deleteRecordingInfo(fileName: fileNames)
        }
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100, // 提高采样率，提升音量与音质
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
            AVEncoderBitRateKey: 192000 // 提高比特率
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            currentRecordTime = 0
            recordTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.currentRecordTime += 1
                self.timeBlocks?()
                print("录音时长: \(self.formatTime(self.currentRecordTime))")
            }
            
        } catch {
            print("录音失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 停止录音
    func stopRecording() {
        audioRecorder?.stop()
        recordTimer?.invalidate()
        recordTimer = nil
        
        print("录音结束，总时长: \(formatTime(currentRecordTime))")
    }
    
    // 保存录音
    func saveRecording() {
        if let url = audioRecorder?.url {
            print("录音文件保存到: \(url)")
            saveRecordingInfo(url: url, duration: currentRecordTime)
            if saveEndBlocks != nil {
                saveEndBlocks!(url)
            }
        }
    }
    
    // MARK: - 播放录音
    func playRecording(url: URL? = nil) {
        let playURL = url ?? lastRecordingURL
        guard let url = playURL else {
            print("没有录音文件可播放")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.volume = 1.0 // 保证播放音量最大
            audioPlayer?.play()
            
            currentPlayTime = 0
            playTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if let player = self.audioPlayer {
                    self.currentPlayTime = player.currentTime
                    print("播放进度: \(self.formatTime(self.currentPlayTime)) / \(self.formatTime(player.duration))")
                }
            }
        } catch {
            print("播放失败: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 停止播放
    func stopPlaying() {
        audioPlayer?.stop()
        playTimer?.invalidate()
        playTimer = nil
    }
    
    // MARK: - 保存录音信息（文件名唯一）
    private func saveRecordingInfo(url: URL, duration: TimeInterval) {
        var recordings = UserDefaults.standard.array(forKey: "recordings") as? [[String: Any]] ?? []
        
        let fileName = url.deletingPathExtension().lastPathComponent
        recordings.removeAll { dict in
            if let path = dict["filePath"] as? String {
                return path.contains(fileName)
            }
            return false
        }
        
        let info: [String: Any] = [
            "filePath": url.path,
            "duration": duration,
            "date": Date().timeIntervalSince1970
        ]
        recordings.append(info)
        UserDefaults.standard.set(recordings, forKey: "recordings")
        print("录音信息已保存，总录音数: \(recordings.count)")
    }
    
    // MARK: - 删除指定文件录音
    func deleteRecording(fileName: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(fileName).m4a")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            try? FileManager.default.removeItem(at: fileURL)
        }
        deleteRecordingInfo(fileName: fileName)
    }
    
    private func deleteRecordingInfo(fileName: String) {
        var recordings = UserDefaults.standard.array(forKey: "recordings") as? [[String: Any]] ?? []
        recordings.removeAll { dict in
            if let path = dict["filePath"] as? String {
                return path.contains(fileName)
            }
            return false
        }
        UserDefaults.standard.set(recordings, forKey: "recordings")
    }
    
    // MARK: - 掐头去尾裁剪保存新文件
    func trimRecording(sourceFileName: String, targetFileName: String, headTrim: TimeInterval, tailTrim: TimeInterval, completion: @escaping (URL?) -> Void) {
        
        let sourceURL = getDocumentsDirectory().appendingPathComponent("\(sourceFileName).m4a")
        let targetURL = getDocumentsDirectory().appendingPathComponent("\(targetFileName).m4a")
        
        guard FileManager.default.fileExists(atPath: sourceURL.path) else {
            print("源文件不存在: \(sourceURL.path)")
            completion(nil)
            return
        }
        
        let asset = AVAsset(url: sourceURL)
        let totalDuration = CMTimeGetSeconds(asset.duration)
        
        let startTime = max(0, headTrim)
        let endTime = min(totalDuration, totalDuration - tailTrim)
        
        guard endTime > startTime else {
            print("裁剪参数不正确，结果时长 <= 0")
            completion(nil)
            return
        }
        
        let start = CMTime(seconds: startTime, preferredTimescale: 600)
        let end = CMTime(seconds: endTime, preferredTimescale: 600)
        let timeRange = CMTimeRangeFromTimeToTime(start: start, end: end)
        
        if FileManager.default.fileExists(atPath: targetURL.path) {
            try? FileManager.default.removeItem(at: targetURL)
            deleteRecordingInfo(fileName: targetFileName)
        }
        
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            print("无法创建导出会话")
            completion(nil)
            return
        }
        
        exporter.outputURL = targetURL
        exporter.outputFileType = .m4a
        exporter.timeRange = timeRange
        
        exporter.exportAsynchronously {
            switch exporter.status {
            case .completed:
                let duration = endTime - startTime
                self.saveRecordingInfo(url: targetURL, duration: duration)
                print("裁剪完成: \(targetURL.path), 时长: \(self.formatTime(duration))")
                completion(targetURL)
            case .failed:
                print("裁剪失败: \(exporter.error?.localizedDescription ?? "")")
                completion(nil)
            case .cancelled:
                print("裁剪取消")
                completion(nil)
            default:
                completion(nil)
            }
        }
    }
    
    // MARK: - 获取所有录音信息
    func getAllRecordings() -> [[String: Any]] {
        return UserDefaults.standard.array(forKey: "recordings") as? [[String: Any]] ?? []
    }
    
    // MARK: - 工具方法
    private func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    public func formatTime(_ time: TimeInterval) -> String {
        let min = Int(time) / 60
        let sec = Int(time) % 60
        return String(format: "0:%02d:%02d", min, sec)
    }
}


class LibraryFileManager {
    
    static let shared = LibraryFileManager()
    
    private let subdirectoryName = "music_list"
    
    private init() {
        createSubdirectoryIfNeeded()
    }
    
    public func subdirectoryURL() -> URL {
        let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        return libraryURL.appendingPathComponent(subdirectoryName)
    }
    
    private func createSubdirectoryIfNeeded() {
        let url = subdirectoryURL()
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("创建自定义子目录失败: \(error)")
            }
        }
    }
    
    func fileCount() -> Int {
        return allFileURLs().count
    }
    
    /// 获取自定义子目录下所有文件 URL（按添加时间倒序）
    func allFileURLs() -> [URL] {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: subdirectoryURL(),
                                                                    includingPropertiesForKeys: [.creationDateKey],
                                                                    options: [.skipsHiddenFiles])
            // 按创建时间倒序
            let sortedFiles = files.sorted { file1, file2 in
                let date1 = (try? file1.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                let date2 = (try? file2.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? Date.distantPast
                return date1 > date2
            }
            return sortedFiles
        } catch {
            print("获取文件列表失败: \(error)")
            return []
        }
    }
    
    @discardableResult
    func deleteFile(nameWithoutExtension: String) -> Bool {
        let fileManager = FileManager.default
        let directory = subdirectoryURL()
        
        do {
            let files = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: [.creationDateKey], options: [.skipsHiddenFiles])
            if let fileToDelete = files.first(where: { $0.deletingPathExtension().lastPathComponent == nameWithoutExtension }) {
                try fileManager.removeItem(at: fileToDelete)
                print("删除成功: \(fileToDelete.lastPathComponent)")
                return true
            } else {
                print("文件不存在: \(nameWithoutExtension)")
                return false
            }
            
        } catch {
            print("删除文件失败: \(error)")
            return false
        }
    }
    
    @discardableResult
    func saveFile(data: Data, name: String) -> Bool {
        let fileURL = subdirectoryURL().appendingPathComponent(name)
        do {
            try data.write(to: fileURL)
            // 保存完成后自动更新文件的创建日期到现在（确保倒序正确）
            try FileManager.default.setAttributes([.creationDate: Date()], ofItemAtPath: fileURL.path)
            return true
        } catch {
            print("保存文件失败: \(error)")
            return false
        }
    }
    
    func fileURL(name: String) -> URL {
        let files = allFileURLs()
        if let matchedFile = files.first(where: { $0.deletingPathExtension().lastPathComponent == name }) {
            return matchedFile
        }
        return subdirectoryURL().appendingPathComponent(name)
    }
}

class LocalImageManager {
    
    static let shared = LocalImageManager()
    
    private let subdirectoryName = "music_image"
    
    private init() {
        createSubdirectoryIfNeeded()
    }
    
    private func imagesDirectory() -> URL {
        let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        return libraryURL.appendingPathComponent(subdirectoryName)
    }
    
    private func createSubdirectoryIfNeeded() {
        let url = imagesDirectory()
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("创建子目录失败: \(error)")
            }
        }
    }
    
    @discardableResult
    func saveImage(_ image: UIImage, name: String) -> Bool {
        let fileName = name.hasSuffix(".png") ? name : "\(name).png"
        let fileURL = imagesDirectory().appendingPathComponent(fileName)
        
        guard let data = image.pngData() else { return false }
        
        do {
            try data.write(to: fileURL)
            return true
        } catch {
            print("保存图片失败: \(error)")
            return false
        }
    }
    
    func getImage(name: String) -> UIImage? {
        let fileName = name.hasSuffix(".png") ? name : "\(name).png"
        let fileURL = imagesDirectory().appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    @discardableResult
    func deleteImage(name: String) -> Bool {
        let fileName = name.hasSuffix(".png") ? name : "\(name).png"
        let fileURL = imagesDirectory().appendingPathComponent(fileName)
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return false }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            return true
        } catch {
            print("删除图片失败: \(error)")
            return false
        }
    }
    
    func allImageURLs() -> [URL] {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: imagesDirectory(),
                                                                    includingPropertiesForKeys: nil,
                                                                    options: [.skipsHiddenFiles])
            return files
        } catch {
            print("获取图片列表失败: \(error)")
            return []
        }
    }
}
