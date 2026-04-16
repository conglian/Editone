//
//  LaunchConfigManager.swift
//

import Foundation
import HandyJSON
import FacebookCore
import FirebaseRemoteConfig
internal import FBSDKCoreKit

class EoLaunchConfigManager {
    
    static let share = EoLaunchConfigManager()
    
    var isMax = false

    func fetchConfig(timeOut: TimeInterval = TimeInterval(EO_LAUNCH_WATIE_TIME_OUT), completion: (() -> Void)?, timeOutHandler: (() -> Void)?) {
        let group = DispatchGroup()
        var tasks = [DispatchWorkItem]()
        DispatchQueue.global(qos: .background).async {
            
            group.enter()
            let task2 = DispatchWorkItem {
//                EO_CloakManager.default.cloakUpload { type in
//                    group.leave()
//                }
            }
            tasks.append(task2)
            DispatchQueue.global(qos: .background).async(execute: task2)
            
            group.enter()
            let task1 = DispatchWorkItem {
                self.getFirebaseRecomteConfig {
                    group.leave()
                }
            }
            tasks.append(task1)
            DispatchQueue.global(qos: .background).async(execute: task1)
            
            let timeout = DispatchTime.now() + timeOut // 10 秒钟的超时时间
            if group.wait(timeout: timeout) == .timedOut {
                // 取消尚未开始执行的任务
                for task in tasks {
                    if !task.isCancelled {
                        task.cancel()
                    }
                }
                DispatchQueue.main.async {
//                    ADManager.share.isMax = true
                    self.isMax = true
                    timeOutHandler?()
                }
            } else {
                group.notify(queue: .main) {
                    completion?()
                }
            }
        }
    }
    
    private func getFirebaseRecomteConfig(completion: (() -> Void)?) {
                        
        let remoteConfig = RemoteConfig.remoteConfig()

        let settings = RemoteConfigSettings()

        settings.minimumFetchInterval = 0

        remoteConfig.configSettings = settings

        remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
                print("Config fetched!")
                remoteConfig.activate { changed, error in
                    
                    let pulse_ad = remoteConfig.configValue(forKey: "edoen_ad_config").stringValue
                    print("pulse_ad")
                    print(pulse_ad)
                    if let dict = Util.stringToDictionary(pulse_ad) {
                        if  let admodel =  EoADInfobaseModel.deserialize(from: dict) {
                            EoADManager.share.adModel = admodel
                        }
                    }
                    
                    let fb_id = remoteConfig.configValue(forKey: "edit_fabo_id").stringValue
                    if let fb_id_dict = Util.stringToDictionary(fb_id) {
                        self.initializeFacebookSDK(appID: fb_id_dict["id"] as! String, clientToken: fb_id_dict["token"] as! String)
                    }
                    print("fb_id")
                    print(fb_id)
                    
                    let edoen_cd = remoteConfig.configValue(forKey: "edoen_cd").numberValue
                    print("edoen_cd")
                    EoADManager.share.maxTime = Int(truncating: edoen_cd)
                    print(edoen_cd)

                }
            }
        }
     }
    
    func initializeFacebookSDK(appID: String, clientToken: String) {
        // 创建一个 Settings 对象
        Settings.appID = appID
        Settings.clientToken = clientToken
        Settings.isAutoLogAppEventsEnabled = false
        Settings.isAdvertiserIDCollectionEnabled = false
        // 初始化 SDK
        DispatchQueue.main.async {
            ApplicationDelegate.shared.application(
                UIApplication.shared,
                didFinishLaunchingWithOptions: nil
            )
        }
        Eo_Log("Facebook SDK initialized with AppID: \(appID)")
    }
    
    
}
