import UIKit
import GoogleMobileAds
import AdjustSdk
internal import AVFAudio

class GADAppOpenAdManager: NSObject {
    
    static let share = GADAppOpenAdManager()
    
    // MARK: - Ad
    var appOpenAd: AppOpenAd?
    var rewardedAd: RewardedAd?
    
    /// 打点
    var editone_open: EoADInfoDataModel?
    
    /// 加载时间
    var loadTime: Date?
    
    /// 超时（3.8小时）
    let timeoutInterval: TimeInterval = 13800
    
    /// 当前加载索引（关键）
    private var currentIndex: Int = 0
    
    /// 防止重复加载（关键）
    private var isLoading: Bool = false
    
    var isPlayMusicing = false
    
    /// 本地存储 key
    private let lastShowTimeKey = "LastAdShowTime"
    
    var adDidCloseHandler: (() -> Void)?
    
    // MARK: - 判断广告是否有效
    public func wasLoadTimeLessThanNHoursAgo(timeoutInterval: TimeInterval) -> Bool {
        if let loadTime = loadTime {
            return Date().timeIntervalSince(loadTime) < timeoutInterval
        }
        return false
    }
    
    public func isAdAvailable() -> Bool {
        return appOpenAd != nil && wasLoadTimeLessThanNHoursAgo(timeoutInterval: timeoutInterval)
    }
    
    // MARK: - 开始加载（入口）
    func updateloadAppoen() {
        // ❗️防止重复触发
        guard !isLoading else { return }
        isLoading = true
        currentIndex = 0
        loadNextAd()
    }
    
    // MARK: - 串行加载核心逻辑（关键）
    private func loadNextAd() {
        guard let list = EoADManager.share.adModel?.edoen_elaunch,
              list.count > 0 else {
            isLoading = false
            return
        }
        
        // 排序
        let sorted = list.sorted { ($0.edguhrky ?? 0) > ($1.edguhrky ?? 0) }
        
        // 越界结束
        if currentIndex >= sorted.count {
            isLoading = false
            print("❌ All AppOpenAd load failed")
            return
        }
        
        // 当前广告可用则不继续加载
        if isAdAvailable() {
            isLoading = false
            return
        }
        
        let model = sorted[currentIndex]
        let adUnitID = model.xczhtpce ?? "ca-app-pub-7744353666835825/1458213635"
        
        currentIndex += 1
        Eo_Log("[Ad begin load Adid=\(adUnitID) weight=\(Int(model.edguhrky ?? 0)) GADAppOpenAd \(currentIndex)]")
        self.editone_open = model
        
        let request = Request()
        
        AppOpenAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ AppOpenAd load failed: adUnitID = \(adUnitID) \(error.localizedDescription)")
                
                // 延迟12秒再尝试下一个
                DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                    self.loadNextAd()
                }
                return
            }
            
            // ✅ 成功
            print("✅ AppOpenAd load success")
            
            DispatchQueue.main.async {
                self.appOpenAd = ad
                self.loadTime = Date()
                self.appOpenAd?.fullScreenContentDelegate = self
            }
            
            self.isLoading = false
        }
    }
    
    // MARK: - 展示广告（外部调用）
    func showAdIfAvailable(from rootVC: UIViewController) -> Bool {
        // ❗️关键保护
        guard UIApplication.shared.applicationState == .active else {
            print("❌ App not active, skip show")
            return false
        }
        // 无缓存 下次触发ad场景在此请求
        if self.appOpenAd == nil && self.currentIndex >= EoADManager.share.adModel?.edoen_elaunch?.count ?? 0 {
            self.currentIndex = 0
            currentIndex = 0
            appOpenAd = nil
            loadTime = nil
            isLoading = false
            self.loadNextAd()
        }
        // 判断是否有广告可用
        guard isAdAvailable(), let ad = appOpenAd else {
            Eo_Log("❌ No ad available to show")
//            UIApplication.shared.currentKeyWindow?.showToast(text: "❌ No ad available to show")
            return false
        }
        
        if !EoADManager.share.eo_isShowAdmon() {
            Eo_Log("❌ ad limited available to show")
//            UIApplication.shared.currentKeyWindow?.showToast(text: "❌ ad limited available to show")
            return false
        }
        
        // 判断与上次展示间隔是否超过60秒
        let lastShowTime = UserDefaults.standard.object(forKey: lastShowTimeKey) as? Date
        if let last = lastShowTime, Date().timeIntervalSince(last) < TimeInterval(EoADManager.share.maxTime) {
            print("❌ Last ad shown less than \(EoADManager.share.maxTime)s ago")
            return false
        }
        
        ad.present(from: rootVC)
        return true
    }
    
    // MARK: - 首页
    func setRootTabbarVC() {
        // your code
    }
    
    // MARK: - Adjust
    func addAdjustAdmob(
        ad_source: String,
        ad_network: String,
        ad_code_id: String,
        ad_pos_id: String,
        ad_format: String,
        ad_pre_ecpm: Double,
        currency: String
    ) {
        let adRevenue = ADJAdRevenue(source: ad_source)
        adRevenue?.setRevenue(ad_pre_ecpm, currency: currency)
        adRevenue?.addCallbackParameter("ad_network", value: ad_network)
        adRevenue?.addPartnerParameter("ad_source", value: ad_source)
        adRevenue?.addPartnerParameter("ad_code_id", value: ad_code_id)
        adRevenue?.addPartnerParameter("ad_pos_id", value: ad_pos_id)
        adRevenue?.addPartnerParameter("ad_format", value: ad_format)
        Adjust.trackAdRevenue(adRevenue!)
    }
}

// MARK: - Delegate
extension GADAppOpenAdManager: FullScreenContentDelegate {
    
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("App open ad will present")
        
        UserDefault.isLuach_show_ad = true;
        isPlayMusicing = EoMusicVC.shared.audioPlayer?.isPlaying ?? false
        if isPlayMusicing {
            EoMusicVC.shared.audioPlayer?.pause()
        }
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("App open ad dismissed")
        
        // 更新 lastShowTime 在广告关闭后
        UserDefaults.standard.set(Date(), forKey: lastShowTimeKey)
        
        UserDefault.luanch_ad_wating = false
        
        UserDefault.isLuach_show_ad = false;
        
        UserDefault.isLuach_time_end = true;

        NotificationCenter.default.post(name: EO_NOTIFICATION_LOADING_FINISHED, object: nil)
        if isPlayMusicing {
            EoMusicVC.shared.audioPlayer?.play()
        }
        
        if adDidCloseHandler != nil {
            adDidCloseHandler!()
        }
        // **重置加载状态**
        currentIndex = 0
        appOpenAd = nil
        loadTime = nil
        isLoading = false
        // 重新加载广告（防止并发）
        updateloadAppoen()
    }

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("App open ad clicked")
    }

    func ad(
        _ ad: FullScreenPresentingAd,
        didFailToPresentFullScreenContentWithError error: Error
    ) {
        print("❌ present failed: \(error.localizedDescription)")
        // **重置加载状态**
        currentIndex = 0
        appOpenAd = nil
        loadTime = nil
        isLoading = false
                
        // 重新加载广告（防止并发）
        updateloadAppoen()
    }
}
