
import UIKit
import GoogleMobileAds

class GoAdBasicNativeView: NativeAdView {
    
    lazy var EO_mediaNaView: MediaView = {
        let view = MediaView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var EO_iconNaView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()

    lazy var EO_headlineNaLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.font = .systemFont(ofSize: 14)
        return lab
    }()
    
    lazy var EO_adLogoLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 10)
        lab.backgroundColor = UIColor.init(hexString: "666666")
        lab.layer.cornerRadius = 5
        lab.layer.masksToBounds = true
        lab.textAlignment = .center
        lab.text = "AD"
        return lab
    }()
   
    lazy var EO_bobyNaLabel: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.init(hexString: "333333")
        lab.font = .systemFont(ofSize: 12)
        return lab
    }()
    
    lazy var EO_callToActionNaBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.setTitle("install", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 14)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.isUserInteractionEnabled = false
        btn.backgroundColor = UIColor.main
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(hexString: "FFFFFF")
        putupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func putupViews() {
        
    }
}

