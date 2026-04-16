//
//  AppDelegate.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 16/03/2026.
//

import UIKit
import CoreData
import SVProgressHUD
import AppTrackingTransparency
import AdSupport
import GoogleMobileAds
import FirebaseCore
import FirebaseAnalytics // 如果你使用 Firebase，可以导入
import UserMessagingPlatform
import FacebookCore
internal import FBSDKCoreKit
import FirebaseCrashlytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupSVProgressHUD()
        // Initialize the Google Mobile Ads SDK.
        initAdmobSdk()
        FirebaseApp.configure()
        EoADManager.share.eo_getBunldInfoData()
        EoLaunchLoadingManger.share.startRun()
        return true
        
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    
    func initAdmobSdk(){
        MobileAds.shared.start { status in
            var canLoadAds = false
            
            // 遍历所有 AdapterStatus
            for (_, adapterStatus) in status.adapterStatusesByClassName {
                if adapterStatus.state == .ready {
                    canLoadAds = true
                    break
                }
            }
            
            if canLoadAds {
                print("✅ MobileAds initialized successfully, start loading ads")
                // 初始化成功后再加载开屏和插屏
                GADAppOpenAdManager.share.updateloadAppoen()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    GADInterstitialAdManager.share.updateinterstitial()
                }
            } else {
                print("❌ MobileAds initialization not ready yet")
                // 可以考虑延迟重试
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    GADAppOpenAdManager.share.updateloadAppoen()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        GADInterstitialAdManager.share.updateinterstitial()
                    }
                }
            }
        }
        MobileAds.shared.requestConfiguration.testDeviceIdentifiers = [ "a484f9c25ed05d0c62b12bc34072f49f" ];
    }
    
    func setupSVProgressHUD() {
        // HUD 不拦截触摸
        SVProgressHUD.setDefaultMaskType(.none)
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }


}

