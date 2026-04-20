import UIKit
import GoogleMobileAds
import AdjustSdk
internal import AVFAudio

// MARK: - 插屏1
class GADInterstitialAdManager: NSObject {
    
    static let share = GADInterstitialAdManager()
    
    public var interstitial: InterstitialAd?
    var rewardedAd: RewardedAd?
    
    var editone_open: EoADInfoDataModel?
    
    private var currentIndex: Int = 0
    private var isLoading: Bool = false
    private var loadTime: Date?
    private let timeoutInterval: TimeInterval = 3000
    private let lastShowTimeKey = "LastAdShowTime"
    
    var adDidCloseHandler: (() -> Void)?
    
    var isPlayMusicing = false
    
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
    
    public func isAdAvailable() -> Bool {
        if let ad = interstitial, let loadTime = loadTime {
            return Date().timeIntervalSince(loadTime) < timeoutInterval
        }
        return false
    }
    
    func updateinterstitial() {
        guard !isLoading else { return }
        isLoading = true
        currentIndex = 0
        loadNextInterstitial()
    }
    
    private func loadNextInterstitial() {
        guard let list = EoADManager.share.adModel?.edoen_int_emain, !list.isEmpty else {
            isLoading = false
            return
        }
        let sorted = list.sorted { ($0.edguhrky ?? 0) > ($1.edguhrky ?? 0) }
        
        if currentIndex >= sorted.count {
            isLoading = false
            print("❌ All InterstitialAd load failed")
            return
        }
        
        if isAdAvailable() {
            isLoading = false
            return
        }
        
        let model = sorted[currentIndex]
        currentIndex += 1
        self.editone_open = model
        
        let request = Request()
        let adUnitID = model.xczhtpce ?? "ca-app-pub-7744353666835825/4004485926"
        
        Eo_Log("[Ad begin load Adid=\(adUnitID) weight=\(Int(model.edguhrky ?? 0)) GADInterstitialAd1 \(currentIndex)]")

        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ InterstitialAd load failed: \(error.localizedDescription)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                    self.loadNextInterstitial()
                }
                return
            }
            
            print("✅ InterstitialAd load success")
            DispatchQueue.main.async {
                self.interstitial = ad
                self.loadTime = Date()
                self.interstitial?.fullScreenContentDelegate = self
            }
            self.isLoading = false
        }
    }
    
    func showAdIfAvailable(from rootVC: UIViewController) {
        // ❗️关键保护
        guard UIApplication.shared.applicationState == .active else {
            print("❌ App not active, skip show")
            return
        }
        // 无缓存 下次触发ad场景在此请求
        if self.interstitial == nil && self.currentIndex >= EoADManager.share.adModel?.edoen_int_emain?.count ?? 0 {
            currentIndex = 0
            interstitial = nil
            loadTime = nil
            isLoading = false
            self.updateinterstitial()
        }
        guard isAdAvailable(), let ad = interstitial else {
//            Eo_Log("❌ No InterstitialAd available to show")
//            UIApplication.shared.currentKeyWindow?.showToast(text: "❌ No ad available to show")
            if adDidCloseHandler != nil {
                adDidCloseHandler!()
            }
            return
        }
        
        if !EoADManager.share.eo_isShowAdmon() {
            Eo_Log("❌ ad limited available to show")
//            UIApplication.shared.currentKeyWindow?.showToast(text: "❌ ad limited available to show")
            if adDidCloseHandler != nil {
                adDidCloseHandler!()
            }
            return
        }
        
        let lastShowTime = UserDefaults.standard.object(forKey: lastShowTimeKey) as? Date
        if let last = lastShowTime, Date().timeIntervalSince(last) < TimeInterval(EoADManager.share.maxTime) {
            print("❌ Last ad shown less than \(EoADManager.share.maxTime)s ago")
            
            if adDidCloseHandler != nil {
                adDidCloseHandler!()
            }
            
            return
        }
        
        UserDefault.isIntsll_show_ad = true
        ad.present(from: rootVC)
    }
}

extension GADInterstitialAdManager: FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        EoADManager.share.editone_ad_show = (EoADManager.share.editone_ad_show ?? 0) + 1
        EoADManager.share.eo_updatexUu_date()
        print("InterstitialAd will present")
        isPlayMusicing = EoMusicVC.shared.audioPlayer?.isPlaying ?? false
        if isPlayMusicing {
            EoMusicVC.shared.audioPlayer?.pause()
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("InterstitialAd did dismiss")
        UserDefault.isIntsll_show_ad = false
        // 更新 lastShowTime
        UserDefaults.standard.set(Date(), forKey: lastShowTimeKey)
        // **重置加载状态**
        currentIndex = 0
        interstitial = nil
        loadTime = nil
        isLoading = false
        updateinterstitial()
        if isPlayMusicing {
            EoMusicVC.shared.audioPlayer?.play()
        }
        
        if adDidCloseHandler != nil {
            adDidCloseHandler!()
        }
    }
    
    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        EoADManager.share.editone_ad_cilck = (EoADManager.share.editone_ad_cilck ?? 0) + 1
        EoADManager.share.eo_updatexUu_date()
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("InterstitialAd present failed: \(error.localizedDescription)")
        // **重置加载状态**
        currentIndex = 0
        interstitial = nil
        loadTime = nil
        isLoading = false
        updateinterstitial()
    }
}

// MARK: - 插屏2
class GADInterstitial2AdManager: NSObject {
    
    static let share = GADInterstitial2AdManager()
    
    public var interstitial: InterstitialAd?
    var rewardedAd: RewardedAd?
    
    var editone_open: EoADInfoDataModel?
    
    private var currentIndex: Int = 0
    private var isLoading: Bool = false
    private var loadTime: Date?
    private let timeoutInterval: TimeInterval = 3000
    private let lastShowTimeKey = "LastAdShowTime"
    
    var adDidCloseHandler: (() -> Void)?
    
    var isPlayMusicing = false
    
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
    
    public func isAdAvailable() -> Bool {
        if let ad = interstitial, let loadTime = loadTime {
            return Date().timeIntervalSince(loadTime) < timeoutInterval
        }
        return false
    }
    
    func updateinterstitial() {
        guard !isLoading else { return }
        isLoading = true
        currentIndex = 0
        loadNextInterstitial()
    }
    
    private func loadNextInterstitial() {
        guard let list = EoADManager.share.adModel?.edoen_int_emain, !list.isEmpty else {
            isLoading = false
            return
        }
        
        let sorted = list.sorted { ($0.edguhrky ?? 0) > ($1.edguhrky ?? 0) }
        
        if currentIndex >= sorted.count {
            isLoading = false
            print("❌ All InterstitialAd2 load failed")
            return
        }
        
        if isAdAvailable() {
            isLoading = false
            return
        }
        
        let model = sorted[currentIndex]
        currentIndex += 1
        self.editone_open = model
        
        let request = Request()
        let adUnitID = model.xczhtpce ?? "ca-app-pub-1576819475324396/4568830236"
        
        Eo_Log("[Ad begin load GADInterstitialAd2 \(currentIndex)]")
        
        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            guard let self = self else { return }
            
            if let error = error {
                print("❌ InterstitialAd2 load failed: \(error.localizedDescription)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
                    self.loadNextInterstitial()
                }
                return
            }
            
            print("✅ InterstitialAd2 load success")
            DispatchQueue.main.async {
                self.interstitial = ad
                self.loadTime = Date()
                self.interstitial?.fullScreenContentDelegate = self
            }
            self.isLoading = false
        }
    }
    
    func showAdIfAvailable(from rootVC: UIViewController) {
        // ❗️关键保护
        guard UIApplication.shared.applicationState == .active else {
            print("❌ App not active, skip show")
            return
        }
        // 无缓存 下次触发ad场景在此请求
        if self.interstitial == nil && self.currentIndex >= EoADManager.share.adModel?.edoen_int_emain?.count ?? 0 {
            currentIndex = 0
            interstitial = nil
            loadTime = nil
            isLoading = false
            self.updateinterstitial()
        }
        guard isAdAvailable(), let ad = interstitial else {
            Eo_Log("❌ No InterstitialAd2 available to show")
//            UIApplication.shared.currentKeyWindow?.showToast(text: "❌ No ad available to show")
            if adDidCloseHandler != nil {
                adDidCloseHandler!()
            }
            return
        }
        
        if !EoADManager.share.eo_isShowAdmon() {
            Eo_Log("❌ ad limited available to show")
//            UIApplication.shared.currentKeyWindow?.showToast(text: "❌ ad limited available to show")
            if adDidCloseHandler != nil {
                adDidCloseHandler!()
            }
            return
        }
        
        let lastShowTime = UserDefaults.standard.object(forKey: lastShowTimeKey) as? Date
        if let last = lastShowTime, Date().timeIntervalSince(last) < TimeInterval(EoADManager.share.maxTime) {
            print("❌ Last ad shown less than \(EoADManager.share.maxTime)s ago")
            if adDidCloseHandler != nil {
                adDidCloseHandler!()
            }
            return
        }
        UserDefault.isIntsll_show_ad = true
        ad.present(from: rootVC)
    }
}

extension GADInterstitial2AdManager: FullScreenContentDelegate {
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        EoADManager.share.editone_ad_show = (EoADManager.share.editone_ad_show ?? 0) + 1
        EoADManager.share.eo_updatexUu_date()
        print("InterstitialAd2 will present")
        isPlayMusicing = EoMusicVC.shared.audioPlayer?.isPlaying ?? false
        if isPlayMusicing {
            EoMusicVC.shared.audioPlayer?.pause()
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("InterstitialAd2 did dismiss")
        UserDefault.isIntsll_show_ad = false
        UserDefaults.standard.set(Date(), forKey: lastShowTimeKey)
        // **重置加载状态**
        currentIndex = 0
        interstitial = nil
        loadTime = nil
        isLoading = false
        updateinterstitial()
        if isPlayMusicing {
            EoMusicVC.shared.audioPlayer?.play()
        }
        
        if adDidCloseHandler != nil {
            adDidCloseHandler!()
        }
    }
    
    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        EoADManager.share.editone_ad_cilck = (EoADManager.share.editone_ad_cilck ?? 0) + 1
        EoADManager.share.eo_updatexUu_date()
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("InterstitialAd2 present failed: \(error.localizedDescription)")
        // **重置加载状态**
        currentIndex = 0
        interstitial = nil
        loadTime = nil
        isLoading = false
        updateinterstitial()
    }
}
