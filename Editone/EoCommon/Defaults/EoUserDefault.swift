//
//  UserDefault.swift
//
//

import Foundation
import CoreTelephony

class UserDefault {
    
    public class var isLogin: Bool {
        get { UserDefaults.standard.bool(forKey: "NN_isLogin_key") }
        set { UserDefaults.standard.set(newValue, forKey: "NN_isLogin_key") }
    }
    
    public class var record_index: Int {
        get { UserDefaults.standard.integer(forKey: "record_index") }
        set { UserDefaults.standard.set(newValue, forKey: "record_index") }
    }
    
    // 是否今天打开过
    public class var isTodayopen: Bool {
        get { UserDefaults.standard.bool(forKey: "isTodayopen") }
        set { UserDefaults.standard.set(newValue, forKey: "isTodayopen") }
    }
    
    // 是否订阅过
    public class var isSubture: Bool {
        get { UserDefaults.standard.bool(forKey: "isSubture") }
        set { UserDefaults.standard.set(newValue, forKey: "isSubture") }
    }
    
    // 订阅A_B_C类型
    public class var pulse_vip: String {
        get { UserDefaults.standard.string(forKey: "pulse_vip") ?? "A" }
        set { UserDefaults.standard.set(newValue, forKey: "pulse_vip") }
    }
    
    // 保存今天的日期
    public class var isTodayDate: String {
        get { UserDefaults.standard.string(forKey: "isTodayDate") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "isTodayDate") }
    }
    
    // 保存Vip到期时间戳
    public class var isvipDate: Double {
        get { UserDefaults.standard.double(forKey: "isvipDate") ?? 0}
        set { UserDefaults.standard.set(newValue, forKey: "isvipDate") }
    }
    
    // 订阅测试 是否显示
    public class var pulse_enter: Bool {
        get { UserDefaults.standard.bool(forKey: "pulse_enter") }
        set { UserDefaults.standard.set(newValue, forKey: "pulse_enter") }
    }
    
    
    
    // 判断是否Vip
    static func getisVip() -> Bool {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Double(timeInterval)
        Eo_Log("会员过期时间戳\(UserDefault.isvipDate)")
        Eo_Log("显示当前时间戳\(timeStamp)")
        if UserDefault.isvipDate > timeStamp {
            return true
        }
        return false
    }
    
    /// IP地址
    public class var current_IP: String {
        get { UserDefaults.standard.string(forKey: "EO_current_ip_key") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "EO_current_ip_key") }
    }
    
}

final class CacheAutoRelease {

    // Shared instance
    static let shared: CacheAutoRelease = CacheAutoRelease()

    // Shared cache
    private static let cache: NSCache<NSString, AnyObject> = {

        let cache = NSCache<NSString, AnyObject>()
        return cache
    }()

    private init(){}

    // Save data to cache
    func cache(object: AnyObject, key: String) {
        CacheAutoRelease.cache.setObject(object, forKey: key as NSString)
    }

    // Retrive data from cache
    func getFromCache(key: String) -> AnyObject? {
        return CacheAutoRelease.cache.object(forKey: key as NSString)
    }
}
