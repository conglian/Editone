//
//  AudioPlayer.swift
//
//

import Foundation
import AVFoundation

class AudioPlayer {
    
    static let share = AudioPlayer()
    
    private var audioPlayer: AVAudioPlayer?
    
    func playSound(named name: String) {
        guard let soundURL = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Error: Sound file not found!")
            return
        }
        
        do {
            // 设置音频会话的类别为playback，并启用默认的外放选项
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
            
            // 激活音频会话
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 0.5
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func playAudio(audioURL: URL) {
        do {
            // 设置音频会话的类别为playback，并启用默认的外放选项
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
            // 激活音频会话
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func playAudio(from url: URL) {
        do {
            // 设置音频会话的类别为playback，并启用默认的外放选项
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, options: .defaultToSpeaker)
            // 激活音频会话
            try AVAudioSession.sharedInstance().setActive(true)
            // 初始化AVAudioPlayer实例
            audioPlayer = try AVAudioPlayer(contentsOf: URL(string: "")!)
            audioPlayer?.volume = 1.0
            audioPlayer?.numberOfLoops = -1
            // 开始播放音频
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("播放音频失败：\(error)")
        }
    }
    
    func setLooping(isLooping: Bool) {
        audioPlayer?.numberOfLoops = isLooping ? -1 : 0
    }
    
    func setPlaybackRate(rate: Float) {
        audioPlayer?.rate = rate
    }
    
    func setVolume(volume: Float) {
        audioPlayer?.volume = volume
    }
    
    func playSoundWithDuration(duration: TimeInterval) {
        let originalNumberOfLoops = audioPlayer?.numberOfLoops
        let originalPlayRate = audioPlayer?.rate
        let originalVolume = audioPlayer?.volume
        
        audioPlayer?.numberOfLoops = -1 // 设置为循环播放
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.audioPlayer?.stop()
            // 还原之前的设置
            self.audioPlayer?.numberOfLoops = originalNumberOfLoops ?? 0
            self.audioPlayer?.rate = originalPlayRate ?? 1.0
            self.audioPlayer?.volume = originalVolume ?? 1.0
        }
        
        audioPlayer?.play()
    }
    
    func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}
