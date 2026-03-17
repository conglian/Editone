//
//  VideoPlayer.swift
//
//

import UIKit
import AVKit

class VideoPlayer {

    static func play(url: URL, from viewController: UIViewController) {
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        viewController.present(playerViewController, animated: true) {
            player.play()
        }
    }
}
