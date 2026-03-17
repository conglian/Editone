//
//  LocalPlayer.swift
//
//

import Foundation
import AVFoundation

class VoicePlayer {
    
    static let share = VoicePlayer()
    
    private var audioPlayer: AVAudioPlayer?
    private var isPlaying = false
    
    func startPlaying(audioURL: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.numberOfLoops = -1 // 设置为循环播放
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func resumePlaying() {
        audioPlayer?.play()
        isPlaying = true
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
    }
    
    func togglePlayerStatus(audioURL: URL) {
        if isPlaying {
            pausePlaying()
        } else {
            startPlaying(audioURL: audioURL)
        }
    }
    
    var isPlayingStatus: Bool {
        return isPlaying
    }
}
