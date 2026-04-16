

import UIKit
import GoogleMobileAds
import SnapKit

class GoAdSearchNativeView: GoAdBasicNativeView {
    
    override func putupViews() {
        addSubview(EO_mediaNaView)
        addSubview(EO_iconNaView)
        addSubview(EO_headlineNaLabel)
        addSubview(EO_bobyNaLabel)
        addSubview(EO_callToActionNaBtn)
        addSubview(EO_adLogoLabel)
        self.mediaView = EO_mediaNaView
        self.iconView = EO_iconNaView
        self.headlineView = EO_headlineNaLabel
        self.bodyView = EO_bobyNaLabel
        self.callToActionView = EO_callToActionNaBtn
        
        EO_headlineNaLabel.textAlignment = .center
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        EO_iconNaView.snp.makeConstraints { make in
            make.size.equalTo(CGSize.init(width: 56, height: 56))
            make.leading.equalTo(8).priority(999)
            make.bottom.equalTo(-12).priority(999)
        }
        EO_callToActionNaBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-8).priority(999)
            make.size.equalTo(CGSize.init(width: 88, height: 32))
            make.centerY.equalTo(EO_iconNaView.snp.centerY)
        }
        EO_headlineNaLabel.snp.makeConstraints { make in
            make.leading.equalTo(EO_iconNaView.snp.trailing).offset(8)
            make.trailing.equalTo(EO_callToActionNaBtn.snp.leading).offset(-8)
            make.top.equalTo(EO_iconNaView.snp.top).offset(8)
        }
        EO_bobyNaLabel.snp.makeConstraints { make in
            make.leading.equalTo(EO_headlineNaLabel.snp.leading)
            make.trailing.equalTo(EO_headlineNaLabel.snp.trailing)
            make.bottom.equalTo(EO_iconNaView.snp.bottom).offset(-8)
        }
        EO_mediaNaView.snp.makeConstraints { make in
            make.leading.top.equalTo(8).priority(999)
            make.trailing.equalTo(-8).priority(999)
            make.bottom.equalTo(EO_iconNaView.snp.top).offset(-12)
        }
        EO_adLogoLabel.snp.makeConstraints { make in
            make.leading.top.equalTo(5).priority(999)
            make.size.equalTo(CGSize(width: 26, height: 14))
        }
    }
}
