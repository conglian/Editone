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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupSVProgressHUD()
        EoLaunchLoadingManger.share.startRun()
        return true
        
    }
    func setupSVProgressHUD() {
        // HUD 不拦截触摸
        SVProgressHUD.setDefaultMaskType(.none)

    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        requestPermission()
    }
    
    // ATT
    func requestPermission() {
        if #available(iOS 14, *) {
           // 4.GCD 主线程/子线程
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              ATTrackingManager.requestTrackingAuthorization { status in
                  switch status {
                  case .authorized:
                      // Tracking authorization dialog was shown
                      // and we are authorized
                      print("Authorized")
                      // Now that we are authorized we can get the IDFA
                      print(ASIdentifierManager.shared().advertisingIdentifier)
                  case .denied:
                      // Tracking authorization dialog was
                      // shown and permission is denied
                      print("Denied")
                  case .notDetermined:
                      // Tracking authorization dialog has not been shown
                      print("Not Determined")
                  case .restricted:
                      print("Restricted")
                  @unknown default:
                      print("Unknown")
                  }
              }
           }
        }
    }


}

