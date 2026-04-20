import UIKit

class EoLaunchProgressVC: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    private var timer: Timer?
    private var elapsed: TimeInterval = 0
    private let totalDuration: TimeInterval = 10.0
    private let interval: TimeInterval = 0.02
    
    private var hasEnteredHome = false
    private var shouldShowAdWhenActive = false

    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.progress = 0.0

        // 判断是否首次安装
        if isFirstLaunch() {
            // 首次安装 → 不显示广告
            startProgressAnimation(showAd: false)
        } else {
            // 非首次安装 → 保留广告逻辑
            startProgressAnimation(showAd: true)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    /// 判断首次安装
    private func isFirstLaunch() -> Bool {
        let hasLaunchedKey = "hasLaunchedBefore"
        let launchedBefore = UserDefaults.standard.bool(forKey: hasLaunchedKey)
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: hasLaunchedKey)
            UserDefaults.standard.synchronize()
        }
        return !launchedBefore
    }

    /// 启动页进度动画
    private func startProgressAnimation(showAd: Bool) {
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.elapsed += self.interval
            let progress = Float(self.elapsed / self.totalDuration)
            self.progressView.setProgress(progress, animated: true)
            
            // 10秒到 → 强制进入首页
            if self.elapsed >= self.totalDuration {
                UserDefault.isLuach_time_end = true
                timer.invalidate()
                self.enterHome(showAd: showAd)
                return
            }
            
            // 如果10秒内广告加载好了
            if showAd && GADAppOpenAdManager.share.isAdAvailable() {
                timer.invalidate()
                self.enterHome(showAd: showAd)
            }
        }
    }
    
    /// 进入首页
    private func enterHome(showAd: Bool) {
        guard !hasEnteredHome else { return }
        hasEnteredHome = true
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let tabBar = EoCustomTabBarController()
        appDelegate?.window?.rootViewController = tabBar
        appDelegate?.window?.makeKeyAndVisible()
        
        // 尝试展示广告（非首次安装且广告可用）
        if showAd && GADAppOpenAdManager.share.isAdAvailable() {
            if UIApplication.shared.applicationState == .active {
                GADAppOpenAdManager.share.adDidCloseHandler = {}
                GADAppOpenAdManager.share.showAdIfAvailable(from: UIApplication.shared.currentKeyWindow?.rootViewController ?? UIViewController())
            } else {
                print("后台 → 标记，等待前台展示")
                UserDefault.luanch_ad_wating = true
            }
        }
    }
}
