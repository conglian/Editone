//
//  EoLaunchProgressVC.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 16/03/2026.
//

import UIKit

class EoLaunchProgressVC: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progress = 0.0
        startProgressAnimation()
    }

    private func startProgressAnimation() {
        let duration: TimeInterval = 3.0   // 3 秒
        let interval: TimeInterval = 0.02  // 每 0.02 秒更新一次
        let steps = duration / interval
        var currentStep: TimeInterval = 0

        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            currentStep += 1
            let progress = Float(currentStep / steps)
            self.progressView.setProgress(progress, animated: true)

            if progress >= 1.0 {
                timer.invalidate()
                self.switchRootViewController()
            }
        }
    }

    private func switchRootViewController() {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let tabBar = EoCustomTabBarController()
        appDelegate?.window?.rootViewController = tabBar
    }
}
