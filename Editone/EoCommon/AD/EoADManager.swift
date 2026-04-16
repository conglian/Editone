//
//  ADManager.swift
//
//

import UIKit
import WCDBSwift
import GoogleMobileAds
import HandyJSON

class EoADManager : NSObject, FullScreenContentDelegate {
    
    static let share = EoADManager()
    // 广告配置模型
    var adModel : EoADInfobaseModel?
    // 请求是否超出最大s
    var isMax = false
    
    var maxTime : Int = 60;
    
    /// 记录展示次数
    public var editone_ad_show: Int? {
        get { UserDefaults.standard.integer(forKey: "editone_ad_show")}
        set { UserDefaults.standard.set(newValue, forKey: "editone_ad_show") }
    }
    
    /// 记录点击次数
    public var editone_ad_cilck: Int? {
        get { UserDefaults.standard.integer(forKey: "editone_ad_cilck")}
        set { UserDefaults.standard.set(newValue, forKey: "editone_ad_cilck") }
    }
    /// 记录请求日期
    public var editone_date: String? {
        get { UserDefaults.standard.string(forKey: "editone_date") }
        set { UserDefaults.standard.set(newValue, forKey: "editone_date") }
    }
    
    /// 更新请求日期
    func eo_updatexUu_date() {
        if EoADManager.share.editone_date?.count == 0 || EoADManager.share.editone_date != Util.dateinstallToString(date: Date()) {
            EoADManager.share.editone_date = Util.dateinstallToString(date: Date())
            // 重置 次数
            EoADManager.share.editone_ad_show = 0
            EoADManager.share.editone_ad_cilck = 0
        }
    }
    /// 是否显示Admon
    func eo_isShowAdmon() -> Bool {
        if EoADManager.share.adModel == nil {
            EoADManager.share.eo_getBunldInfoData()
        }
        if EoADManager.share.editone_ad_show ?? 0 >= EoADManager.share.adModel?.qycqtozu ?? 40 || EoADManager.share.editone_ad_cilck ?? 0 >= EoADManager.share.adModel?.xczhtpce ?? 15 {
            return false
        }
        return true
    }

    /// 获取广告本地配置
    func eo_getBunldInfoData() {
        guard let path = Bundle.main.path(forResource: "EoadmonJSON", ofType: "json") else { return }
        let localData = NSData.init(contentsOfFile: path)! as Data
            do {
                if let dict = Util.dataToDictionary(data: localData) {
                    if  let admodel =  EoADInfobaseModel.deserialize(from: dict) {
                        EoADManager.share.adModel = admodel
                    }
                }
            } catch {
                debugPrint("ERROR")
            }
    }
    /// 瀑布流获取Admon数据
//    func eo_getadmonglobalQueue(completion: (() -> Void)?) {
//        
//        // 开屏
//        let group = DispatchGroup()
//        var index = 0
//        // 排序
//        let sortedNumbers = self.adModel?.edoen_elaunch?.sorted { (lhs, rhs) in
//            return lhs.edguhrky ?? 0 > rhs.edguhrky ?? 0
//        }
//        // 循环
//            repeat{
//                index = index + 1
//                group.enter()
//                GADAppOpenAdManager.share.editone_open = sortedNumbers?[index - 1] as? EoADInfoDataModel
//                Eo_Log("[Ad begin load GADAppOpenAd AdMob_ID=\(sortedNumbers?[index - 1].xczhtpce ?? "ca-app-pub-7744353666835825/1458213635") \(index)]")
//                if sortedNumbers?[index - 1].tmelvbcd == "open" {
//                    // 开屏获取并缓存
//                    AppOpenAd.load(with: sortedNumbers?[index - 1].xczhtpce ?? "ca-app-pub-7744353666835825/1458213635", request: Request(), completionHandler: { ad, error in
//                        if let error = error {
//                            Eo_Log("[Ad error load GADAppOpenAd]")
//                            group.notify(queue: .main) {
//                                if !self.isMax {
//                                    completion?()
//                                }
//                            }
//                            group.leave()
//                            print("App open ad failed to load with error: \(error.localizedDescription)")
//                        }
//                        if error == nil {
//                            Eo_Log("[Ad success load GADAppOpenAd \(index)]")
//                            DispatchQueue.main.async {
//                                GADAppOpenAdManager.share.appOpenAd = ad
//                                GADAppOpenAdManager.share.loadTime = Date()
//                                GADAppOpenAdManager.share.appOpenAd?.fullScreenContentDelegate = GADAppOpenAdManager.share
//                            }
//                            group.notify(queue: .main) {
//                                if !self.isMax {
//                                    completion?()
//                                }
//                            }
//                            group.leave()
//                            
//                        }
//                        print("App open ad loaded successfully.")
//                        
//                    })
//                
//                } else if sortedNumbers?[index - 1].tmelvbcd == "interstitial" {
//                    let request = Request()
//                    GADInterstitial2AdManager.share.editone_open = sortedNumbers?[index - 1] as? EoADInfoDataModel
//                    InterstitialAd.load(with: sortedNumbers?[index - 1].xczhtpce ?? "ca-app-pub-7744353666835825/4004485926",
//                                                    request: request,
//                                           completionHandler: { ad, error in
//                        if let error = error {
//                            print("App open ad failed to load with error: \(error.localizedDescription)")
//                            Eo_Log("[Ad error load GADAppOpenAd]")
//                            group.notify(queue: .main) {
//                                if !self.isMax {
//                                    completion?()
//                                }
//                            }
//                            group.leave()
//                            return
//                        }
//                        if error == nil {
//                            Eo_Log("[Ad success load GADAppOpenAd \(index)]")
//                            DispatchQueue.main.async {
//                                GADInterstitial2AdManager.share.interstitial = ad
//                                GADInterstitial2AdManager.share.interstitial?.fullScreenContentDelegate = GADInterstitial2AdManager.share
//                            }
//                            group.notify(queue: .main) {
//                                if !self.isMax {
//                                    completion?()
//                                }
//                            }
//                            group.leave()
//                        }
//                      })
//                }
//            }while index < self.adModel?.edoen_elaunch?.count ?? 0
//        // 插屏1
//        GADInterstitialAdManager.share.updateinterstitial()
//    }
    
    
}
