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
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        window.backgroundColor = UIColor.white
//        let loading = EoLaunchProgressVC()
//        appDelegate?.window = window
//        window.rootViewController = loading
//        window.makeKeyAndVisible()
    
    }
}
// MARK: - 前后台相关
extension EoLaunchLoadingManger {
    
    @objc func startupForeGround() {
        Eo_Log("[loading] 热启动进入前台")
        isInBackground = false
        if UserDefault.getisVip() == false {
        
            // 超出3s在展示
            if Date().timeIntervalSince(isInBackground_date ?? Date()) > 3  {
                // 判断缓存是否可用
                
                } else  {
                   
                }
            }
    }
    
    @objc func startupBackGround() {
        Eo_Log("[loading] 进入后台")
        self.isInBackground_date = Date()
        UIViewController.current?.dismiss(animated: true)
        isInBackground = true
    }
}
