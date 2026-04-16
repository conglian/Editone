//
//  EoLaunchProgressVC.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 16/03/2026.
//

import UIKit

// 如果你用 AdMob，请 import GoogleMobileAds
// import GoogleMobileAds

class EoLaunchProgressVC: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    private var timer: Timer?
    private var currentStep: TimeInterval = 0
    private var steps: TimeInterval = 0
    private let totalDuration: TimeInterval = 10.0 // 10 秒动画
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progress = 0.0
        startProgressAnimation()
    }
    
    private func startProgressAnimation() {
        let interval: TimeInterval = 0.02
        steps = totalDuration / interval
        currentStep = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.currentStep += 1
            let progress = Float(self.currentStep / self.steps)
            self.progressView.setProgress(progress, animated: true)
            
            if progress >= 1.0 {
                let hasLaunchedKey = "hasLaunchedBefore"
                let launchedBefore = UserDefaults.standard.bool(forKey: hasLaunchedKey)
                if !launchedBefore {
                    UserDefaults.standard.set(true, forKey: hasLaunchedKey)
                    UserDefaults.standard.synchronize()
                }
                timer.invalidate()
                self.enterHomeIfNoAd()
            }
            // 判断是否首次安装
            if isFirstLaunch() {
                Eo_Log("首次安装，不显示开屏广告")
            } else {
                // 尝试加载开屏广告
                // 这里根据你的广告 SDK 替换
                GADAppOpenAdManager.share.adDidCloseHandler = { [weak self] in
                    self?.switchRootViewController()
                }
                
                let showstatus = GADAppOpenAdManager.share.showAdIfAvailable(from: self)
                
                adHasBeenShown = showstatus
                
                if showstatus {
                    timer.invalidate()
                }
            }
        }
    }
    
    // MARK: - 首次安装检测
    private func isFirstLaunch() -> Bool {
        let hasLaunchedKey = "hasLaunchedBefore"
        let launchedBefore = UserDefaults.standard.bool(forKey: hasLaunchedKey)
        return !launchedBefore
    }
    
    // MARK: - 广告逻辑
    private var adHasBeenShown = false
    
    private func loadAndShowAppOpenAd() {
        // 这里根据你的广告 SDK 替换
        GADAppOpenAdManager.share.adDidCloseHandler = { [weak self] in
            self?.switchRootViewController()
        }
        
        let showstatus = GADAppOpenAdManager.share.showAdIfAvailable(from: self)
        
        adHasBeenShown = showstatus
        
    }
    
    private func showAppOpenAd() {
        guard !adHasBeenShown else { return }
        adHasBeenShown = true
        
        
    }
    
    // MARK: - 进入首页逻辑
    private func enterHomeIfNoAd() {
        // 防止广告和动画同时触发
        guard let timer = timer else { return }
        timer.invalidate()
        
        if !adHasBeenShown {
            switchRootViewController()
        }
    }
    
    private func switchRootViewController() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let tabBar = EoCustomTabBarController()
        appDelegate?.window?.rootViewController = tabBar
        appDelegate?.window?.makeKeyAndVisible()
    }
}
