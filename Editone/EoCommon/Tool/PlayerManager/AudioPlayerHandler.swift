//
//  AudioPlayerHandler.swift
//

import AVFoundation
class AudioPlayerHandler {
    var audioPlayer: AVAudioPlayer?
    var isPlaying: Bool { audioPlayer?.isPlaying ?? false }
    
    func setupPlayer(with url: URL) { // プレイヤーを作成
        setAudioSessionCategory()
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer?.volume = 1.0
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
    func play(currentTime: Double) { // 再生位置を決めて再生
        audioPlayer?.currentTime = currentTime
        audioPlayer?.play()
    }
    func pause() { // 再生を一時停止
        audioPlayer?.pause()
    }
    
    func setAudioSessionCategory() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.defaultToSpeaker, .allowAirPlay])
            try audioSession.setActive(true)
        } catch {
            print("Failed to set audio session category: \(error.localizedDescription)")
        }
    }
}

