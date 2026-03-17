//
//  Util+Device.swift
//
//

import Foundation
import UIKit
import AdSupport
//import Alamofire

extension Util {
    
    static var kIdfv: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    static var systemName: String {
        return UIDevice.current.systemName
    }
    
    static var adIDFA: String {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
    
    static var app_version: String {
        return EO_APP_VERSION
    }
    
    static var bundleIdentifier: String {
        return "plusefit.health.heartbeat"
    }
    
//    static func getNetWorkStatus() -> String{
//        guard let manager = NetworkReachabilityManager() else {
//            return ""
//        }
//        if manager.isReachableOnCellular {
//            return "Cellular".lowercased()
//        }else if manager.isReachableOnEthernetOrWiFi{
//            return "wifi".lowercased()
//        }else {
//            return ""
//        }
//    }
    
    static var osCountry: String {
        return Locale.current.languageCode ?? "US"
    }
    
    static func isCharging() -> Bool {
        return UIDevice.current.batteryState == .charging
    }
}
