//
//  LaunchLoadingManger.swift
//

import Foundation
import IQKeyboardManager

class EoLaunchLoadingManger {
    
    static let share = EoLaunchLoadingManger()
    
    var isInBackground: Bool = false
    
    var isInBackground_date: Date?
    
    var isShowAdmob = false
    
    var isShowTab = false
 
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(startupForeGround), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startupBackGround), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension EoLaunchLoadingManger {
    
    func startRun() {
        
        EoLaunchConfigManager.share.fetchConfig(timeOut: TimeInterval(EO_LAUNCH_WATIE_TIME_OUT)) {
            
        } timeOutHandler: {
            
        }

        // 初始化
        fetLuaunchConfig()
        /// 键盘设置
        setIQKeyboardManger()
        
    }
    
    func setIQKeyboardManger(){
       let IQ = IQKeyboardManager.shared()
       IQ.isEnabled = true
       IQ.shouldResignOnTouchOutside = true
       IQ.shouldToolbarUsesTextFieldTintColor = false
       IQ.isEnableAutoToolbar = false
    }
    

    
    func fetLuaunchConfig() {
        
        //iOS15 tableView设置sectionHeader高度不生效问题 /备注: Xcode13 以下的为了运行,需要隐藏掉
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        setLaunchVC()
            
    }
    
    func setLaunchVC() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let login = EoLaunchProgressVC()
        appDelegate?.window?.rootViewController = EoBaseNavigationController(rootViewController: login)
        appDelegate?.window?.makeKeyAndVisible()
    
    }
}
// MARK: - 前后台相关
extension EoLaunchLoadingManger {
    
    @objc func startupForeGround() {
        Eo_Log("[loading] 热启动进入前台")
        // 延迟 0.5 秒执行的代码
        if UserDefault.isLuach_show_ad == false && UserDefault.isIntsll_show_ad == false && UserDefault.isLuach_time_end == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                GADAppOpenAdManager.share.adDidCloseHandler = {}
                GADAppOpenAdManager.share.showAdIfAvailable(from: UIApplication.shared.currentKeyWindow?.rootViewController ?? UIViewController())
            }
        }
        // 冷启动 开屏加载成功未显示，进入首页立即展示
        if UserDefault.luanch_ad_wating == true {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                GADAppOpenAdManager.share.adDidCloseHandler = {}
                GADAppOpenAdManager.share.showAdIfAvailable(from: UIApplication.shared.currentKeyWindow?.rootViewController ?? UIViewController())
            }         }
     
    }
    
    @objc func startupBackGround() {
        Eo_Log("[loading] 进入后台")
    }
}

