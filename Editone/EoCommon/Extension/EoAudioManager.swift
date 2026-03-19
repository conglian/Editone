//
//  AudioManager.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 18/03/2026.
//

import UIKit
internal import AVFAudio
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
    
    override init() {
        super.init()
        recordingSession = AVAudioSession.sharedInstance()
        try? recordingSession.setCategory(.playAndRecord, mode: .default)
        try? recordingSession.setActive(true)
    }
    
    // MARK: - 开始录音
    func startRecording(fileNames: String) {
        let fileName = getDocumentsDirectory().appendingPathComponent("\(fileNames).m4a")
        lastRecordingURL = fileName
        
        // 如果文件存在，先删除
        if FileManager.default.fileExists(atPath: fileName.path) {
            try? FileManager.default.removeItem(at: fileName)
            // 同时删除之前保存的录音信息
            deleteRecordingInfo(fileName: fileNames)
        }
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
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
    
    //保存录音
    func saveRecording() {
        if let url = audioRecorder?.url {
            print("录音文件保存到: \(url)")
            saveRecordingInfo(url: url, duration: currentRecordTime)
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
        
        // 删除同名记录
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
    /// sourceFileName: 已保存的源文件名（不带后缀）
    /// targetFileName: 新生成的文件名（不带后缀）
    /// headTrim: 从开始掐掉的秒数
    /// tailTrim: 从结尾掐掉的秒数
    /// completion: 返回生成的新文件URL
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
        
        // 计算裁剪区间
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
        
        // 删除已存在目标文件
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
