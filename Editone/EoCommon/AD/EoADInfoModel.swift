//
//  ADInfoModel.swift
//

import UIKit
import RxSwift
import RxCocoa
import HandyJSON

struct EoADInfobaseModel: HandyJSON {
    /// 最大展示次数
    var qycqtozu: Int?
    /// 最大点击次数
    var xczhtpce: Int?
    /// 超时时间
    var kdmxhsla: Int?
    /// 开屏
    var edoen_elaunch: [EoADInfoDataModel]?
    /// 插屏
    var edoen_int_emain: [EoADInfoDataModel]?
    
}
struct EoADInfoDataModel: HandyJSON {
    /// 广告类型 interstitial
    var tmelvbcd: String?
    /// admob
    var mahnxlvn: String?
    /// AD_ID
    var xczhtpce: String?
    /// WEIGHT 3000
    var danczyct: Int?
    /// 优先级
    var edguhrky: Int?
}
struct Constants {
#if DEBUG
    static let AdMobAdUnitID = "ca-app-pub-6376713442666922~4807171793"
#else
    static let AdMobAdUnitID = "ca-app-pub-6376713442666922~4807171793"
#endif
  /// AdManager PPID ad unit ID.
  static let AdManagerPPIDAdUnitID = "/6499/example/APIDemo/PPID"

  /// AdManager custom targeting ad unit ID.
  static let AdManagerCustomTargetingAdUnitID = "/6499/example/APIDemo/CustomTargeting"

  /// AdManager category exclusions ad unit ID.
  static let AdManagerCategoryExclusionsAdUnitID = "/6499/example/APIDemo/CategoryExclusion"

  /// Dogs category excliusion.
  static let CategoryExclusionDogs = ""

  /// Cats category exclusion.
  static let CategoryExclusionCats = ""

  /// AdManager ad sizes ad unit ID.
  static let AdManagerAdSizesAdUnitID = "/6499/example/APIDemo/AdSizes"

  /// AdManager app events ad unit ID.
  static let AdManagerAppEventsAdUnitID = "/6499/example/APIDemo/AppEvents"

  /// AdManager Fluid ad size ad unit ID.
  static let AdManagerFluidAdSizeAdUnitID = "/6499/example/APIDemo/Fluid"

}
