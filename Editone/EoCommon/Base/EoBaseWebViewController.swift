//
//  BaseWebViewController.swift
//
//

import UIKit
import WebKit
import RxSwift
import RxCocoa
import SnapKit

class BaseWebViewController: BaseViewController {
    
    /// 导航
    private lazy var navBarView: WebNavBarView = {
        let v = WebNavBarView()
        return v
    }()
    //状态栏颜色
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .default
    }
    
    private lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration.init()
        configuration.preferences.javaScriptEnabled = true
        let webView = WKWebView.init(frame: .zero, configuration: configuration)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.navigationDelegate = self
        return webView
    }()

    init(url: URL) {
        super.init(nibName: nil, bundle: nil)
        self.webView.load(URLRequest(url: url))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bindEvent()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hiddeLoading()
    }
    
    private func configUI() {
        self.view.addSubview(navBarView)
        navBarView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(NAVIGATION_H)
        }
        
        self.view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(navBarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func bindEvent() {
        navBarView.popClickHandler = { [weak self] in
            guard let self = self else { return }
            if self.webView.canGoBack {
                self.webView.goBack()
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension BaseWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showLoading()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hiddeLoading()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hiddeLoading()
    }
}

extension BaseWebViewController {
    
    class WebNavBarView: UIView {
        
        let disposeBag = DisposeBag()
        
        private lazy var backBackButton: UIButton = {
            let v = UIButton(type: .custom)
            v.setImage(UIImage(named: "eo_back_icon"), for: .normal)
            v.adjustsImageWhenHighlighted = false
            return v
        }()
        
        private lazy var appNameLogo: UILabel = {
            let v = UILabel()
            v.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            v.text = EO_APP_NAME
            v.textColor = UIColor.white
            return v
        }()

        var popClickHandler: (() -> Void)?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            configUI()
            bindEvent()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configUI() {
            
            self.backgroundColor = .bgroundColors
            
            self.addSubViews([backBackButton, appNameLogo])
            backBackButton.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.width.equalTo(66)
                make.height.equalTo(44)
                make.bottom.equalToSuperview()
            }
            
            appNameLogo.snp.makeConstraints { make in
                make.centerY.equalTo(backBackButton.snp.centerY)
                make.centerX.equalToSuperview()
            }
        }
        
        private func bindEvent() {
            self.backBackButton.rx.tap.subscribe(onNext: { [weak self] in
                self?.popClickHandler?()
            }).disposed(by: disposeBag)
        }
    }

}
