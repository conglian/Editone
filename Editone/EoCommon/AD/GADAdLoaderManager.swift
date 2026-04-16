//
//  GADAdLoaderManager.swift
//

import UIKit
import GoogleMobileAds

class GADAdLoaderManager: NSObject {
    
    static let share = GADAdLoaderManager()
    // 原生广告
    var adLoader: AdLoader!
    ///  原生广告 view
    var nativeAdView : GoAdBasicNativeView!
        
    var index = 0
    
    func loadnative() {
        if self.index + 1 > EoADManager.share.adModel?.edoen_int_emain?.count ?? 0 {
            return
        }
        // 排序
        let sortedNumbers = EoADManager.share.adModel?.edoen_int_emain?.sorted { (lhs, rhs) in
            return lhs.edguhrky ?? 0 > rhs.edguhrky ?? 0
        }
        Eo_Log("[Ad begin load GADAdLoader \(index)]")
        if self.index >= EoADManager.share.adModel?.edoen_int_emain?.count ?? 0 {
            return
        }
        DispatchQueue.main.async {
            self.nativeAdView = GoAdSearchNativeView()
            self.nativeAdView.isHidden = true
        }
        GADAdLoaderManager.share.adLoader = AdLoader(
            adUnitID: sortedNumbers?[self.index].xczhtpce ?? "ca-app-pub-7744353666835825/1458213635", rootViewController: nil,
            adTypes: [.native], options: nil)
        self.adLoader.delegate = self
        GADAdLoaderManager.share.adLoader.load(Request())

    }
    
    /// Returns a `UIImage` representing the number of stars from the given star rating; returns `nil`
    /// if the star rating is less than 3.5 stars.
    func imageOfStars(from starRating: NSDecimalNumber?) -> UIImage? {
      guard let rating = starRating?.doubleValue else {
        return nil
      }
      if rating >= 5 {
        return UIImage(named: "stars_5")
      } else if rating >= 4.5 {
        return UIImage(named: "stars_4_5")
      } else if rating >= 4 {
        return UIImage(named: "stars_4")
      } else if rating >= 3.5 {
        return UIImage(named: "stars_3_5")
      } else {
        return nil
      }
    }

}
/// 原生广告代理
extension GADAdLoaderManager: NativeAdLoaderDelegate {

    func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
           guard let nativeAdView = nativeAdView else { return }
           nativeAdView.isHidden = false
           nativeAd.delegate = self
           nativeAdView.nativeAd = nativeAd

           (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
           nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

           let mediaContent = nativeAd.mediaContent
           if mediaContent.hasVideoContent {
               mediaContent.videoController.delegate = self
           } else {

           }
           (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
           nativeAdView.bodyView?.isHidden = nativeAd.body == nil

           (nativeAdView.callToActionView as? UIButton)?.setTitle(nativeAd.callToAction, for: .normal)
           nativeAdView.callToActionView?.isHidden = nativeAd.callToAction == nil

           (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
           nativeAdView.iconView?.isHidden = nativeAd.icon == nil

           (nativeAdView.starRatingView as? UIImageView)?.image = imageOfStars(from: nativeAd.starRating)
           nativeAdView.starRatingView?.isHidden = nativeAd.starRating == nil

           (nativeAdView.storeView as? UILabel)?.text = nativeAd.store
           nativeAdView.storeView?.isHidden = nativeAd.store == nil

           (nativeAdView.priceView as? UILabel)?.text = nativeAd.price
           nativeAdView.priceView?.isHidden = nativeAd.price == nil

           (nativeAdView.advertiserView as? UILabel)?.text = nativeAd.advertiser
           nativeAdView.advertiserView?.isHidden = nativeAd.advertiser == nil

           nativeAdView.callToActionView?.isUserInteractionEnabled = false
           
       }
}
extension GADAdLoaderManager: VideoControllerDelegate {

    func videoControllerDidEndVideoPlayback(_ videoController: VideoController) {
  }
}
extension GADAdLoaderManager: AdLoaderDelegate {
    func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: Error) {
        Eo_Log("\(adLoader) failed with error: \(error.localizedDescription)")
        Eo_Log("[Ad error load GADAdLoader \(index)]")
        index =  index + 1
        loadnative()
    }
}
// MARK: - GADNativeAdDelegate implementation
extension GADAdLoaderManager: NativeAdDelegate {

/// 原生点击
    func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        EoADManager.share.editone_ad_cilck = (EoADManager.share.editone_ad_cilck ?? 0) + 1
        EoADManager.share.eo_updatexUu_date()
    Eo_Log("\(#function) called")
  }

    func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
      Eo_Log("\(#function) called")
  }
    func nativeAdWillPresentScreen(_ nativeAd: NativeAd) {
      Eo_Log("\(#function) called")
  }

    func nativeAdWillDismissScreen(_ nativeAd: NativeAd) {
      Eo_Log("\(#function) called")
  }

    func nativeAdDidDismissScreen(_ nativeAd: NativeAd) {
      Eo_Log("\(#function) called")
  }

    func nativeAdWillLeaveApplication(_ nativeAd: NativeAd) {
      Eo_Log("\(#function) called")
  }
}
