//
//  PlayerManager.swift
//
//

import AVFoundation

class PlayerManager {
    var audioPlayer = AudioPlayerHandler()
    
    func setup(originalUrl: URL) {
        audioPlayer.setupPlayer(with: originalUrl)
    }
    
    func play(currentTime: Double) {
        audioPlayer.play(currentTime: currentTime)
    }
    
    func pause() {
        audioPlayer.pause()
    }
}
