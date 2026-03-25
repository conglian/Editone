//
//  LaunchConfigManager.swift
//

import Foundation
import HandyJSON

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
                
//        let remoteConfig = RemoteConfig.remoteConfig()
//
//        let settings = RemoteConfigSettings()
//
//        settings.minimumFetchInterval = 0
//
//        remoteConfig.configSettings = settings
//
//        remoteConfig.fetch { (status, error) -> Void in
//            if status == .success {
//                print("Config fetched!")
//                remoteConfig.activate { changed, error in
//                    
//                }
//            }
//        }
     }
    
    
}
