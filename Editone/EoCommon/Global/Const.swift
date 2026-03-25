//
//  AppConst.swift
//
//

import Foundation
import UIKit

/// 屏幕宽
let WSCREEN = UIScreen.main.bounds.size.width
/// 屏幕高
let HSCREEN = UIScreen.main.bounds.size.height
/// 设计图尺寸
let DESIGN_SCREEN_SIZE = CGSize(width: 375.0, height:  812.0)
/// 宽度比例
let WIDTH_SCALE = WSCREEN / DESIGN_SCREEN_SIZE.width
/// 高度比例
let HEIGHT_SCALE = HSCREEN / DESIGN_SCREEN_SIZE.height
/// 状态栏高度
let STATUS_H = AppConfig.statusBarHeight()
/// 导航栏高度
let NAVIGATION_H = STATUS_H + 44

/// APP名称
let EO_APP_NAME = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "NoChat"
/// APP版本号
let EO_APP_VERSION = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.2"
/// APP build 号
let EO_APP_BUILD_NUMBER = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
/// APP bundle id
let EO_APP_BUNDLE_ID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String ?? "plusefit.health.heartbeats"
/// 用户第一次安装
let EO_USER_IS_FIRST_INSTALL = "\(EO_APP_BUNDLE_ID).user.first.install"
/// 设备ID
let EO_APP_DEVICE_ID = "\(EO_APP_BUNDLE_ID).DeviceKey"
/// 用户token
let EO_APP_USER_TOKEN = "\(EO_APP_BUNDLE_ID).user.token"
/// appstore 链接
let EO_APPSTORE_URL_LINK = "itms-apps://itunes.apple.com/app/id\(EO_APPSTORE_ID)?mt=8"
/// 隐私协议
let EO_APP_PRIVACY_URL_PATH = "https://editone.online/privacy.html"
/// 用户条款
let EO_APP_TERM_URL_PATH = "https://editone.online/terms.html"
/// 意见反馈邮箱地址
let EO_SUPPORT_EMAIL_ADDRESS = "support@editone.online"
/// 启动页等待时长,毫秒
let EO_LAUNCH_WATIE_TIME_OUT: Float = 3.0
/// 加解密钥匙
let EO_APP_Crypto_Key = "\(EO_APP_BUNDLE_ID).endecrypt.private.key"
/// APPSTORE ID
let EO_APPSTORE_ID = ""
// 购买共享密钥
let EO_APPSHAREDSECER_ID = ""
// CLOAK_URL
let EO_CLOAK_URL_KEY = ""
#if DEBUG
let EO_TBA_UPLOAD_URL = ""
#else
let EO_TBA_UPLOAD_URL = ""
#endif
