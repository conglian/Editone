//
//  EoHomeViewController.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 17/03/2026.
//

import UIKit
import SnapKit
import UniformTypeIdentifiers
import UserMessagingPlatform
import AppTrackingTransparency
import AdSupport
import FirebaseAnalytics // 如果你使用 Firebase，可以导入

class EoHomeViewController: BaseViewController, UIDocumentPickerDelegate {
    
    var file_path : URL?
    
    // fileprivate UI variable
    fileprivate lazy var topimageV : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "home_top")
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var titleimage : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "eo_title_top")
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var muisccimage : UIImageView = {
        let v = UIImageView()
        v.contentMode = .center
        v.image = UIImage(named: "eo_music_s_icon")
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var muisc_s_btn: UIButton = {
        let v = UIButton()
        v.isSelected = true
        v.addTarget(self, action: #selector(handleMusicPlaySender), for: .touchUpInside)
        v.setBackgroundImage(UIImage(named: "eo_play_s_icon"), for: .normal)
        v.setBackgroundImage(UIImage(named: "eo_pasue_s_icon"), for: .selected)
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var music_Label : UILabel = {
        let v = UILabel()
        v.textColor = UIColor(hexString: "#FFFFFF", alpha: 1.0)
        v.font = UIFont.systemFont(ofSize: 12)
        v.textAlignment = .center
        v.numberOfLines = 0
        v.text = LibraryFileManager.shared.allFileURLs().first?.deletingPathExtension().lastPathComponent
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var pop_view : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = UIColor.clear  // 背景透明
        v.layer.cornerRadius = 15          // 圆角 15
        v.layer.borderWidth = 1            // 边线宽度 1
        v.layer.borderColor = UIColor.init(hexString: "#FFFFFF", alpha: 0.3).cgColor // 边线颜色（可自定义）
        v.clipsToBounds = true             // 确保圆角生效
        // 设置宽高 115x30
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var music_name_Label : UILabel = {
        let v = UILabel()
        v.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.8)
        v.font = UIFont.systemFont(ofSize: 12)
        v.textAlignment = .center
        v.text = "Music Name"
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var muisic_close_btn: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(handleMusicCloseSender), for: .touchUpInside)
        v.setBackgroundImage(UIImage(named: "eo_close_s_icon"), for: .normal)
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var music_btn: UIButton = {
        let v = UIButton()
        v.isHidden = true
        v.backgroundColor = UIColor(hexString: "#1F2023")
        v.addTarget(self, action: #selector(handleMusicSender), for: .touchUpInside)
        
        // 设置左边上下圆角
        let maskPath = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: 178, height: 52), // 按钮尺寸可随时更新
            byRoundingCorners: [.topLeft, .bottomLeft],
            cornerRadii: CGSize(width: 26, height: 26)
        )
        let maskLayer = CAShapeLayer()
        maskLayer.frame = v.bounds
        maskLayer.path = maskPath.cgPath
        v.layer.mask = maskLayer

        return v
    }()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        Analytics.logEvent("test_event", parameters: [
            "debug": "true"
        ])
                
        configUI()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(showmucis), name: EO_NOTIFICATION_MUSIC_FINISHED, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(dismissmusic), name: EO_NOTIFICATION_dismiss_FINISHED, object: nil)
        
        initmusic_block()
        
        requestUMPConsent()
    }
    
    func requestUMPConsent() {
        // 1️⃣ 重置 Consent 信息
//        ConsentInformation.shared.reset()
        
        // 2️⃣ 创建请求参数
        let params = RequestParameters()
        params.isTaggedForUnderAgeOfConsent = false
        
        // 2.1 强制调试设置（必填，否则 georaphy 无效）
        let debugSettings = DebugSettings()
        debugSettings.geography = .EEA            // 强制 EEA（用于调试）
        if let idfv = UIDevice.current.identifierForVendor?.uuidString {
            debugSettings.testDeviceIdentifiers = [idfv]
        }
        params.debugSettings = debugSettings
        
        // 3️⃣ 请求更新 Consent 信息
        ConsentInformation.shared.requestConsentInfoUpdate(with: params) { error in
            if let error = error {
                print("❌ UMP error: \(error)")
                return
            }
            if ConsentInformation.shared.consentStatus == .required {
                
                // 4️⃣ 加载并在可用时展示 Consent Form（兼容 UMP API）
                ConsentForm.load { form, loadError in
                    if let loadError = loadError {
                        print("❌ consent form 加载失败: \(loadError)")
                    } else if let form = form {
                        form.present(from: self) { dismissError in
                            if let dismissError = dismissError {
                                print("❌ consent form 展示失败: \(dismissError)")
                            }
                            // 5️⃣ 打印结果
                            let status = ConsentInformation.shared.consentStatus
                            switch status {
                            case .required:
                                print("📌 需要同意")
                            case .notRequired:
                                print("📌 不需要同意")
                            case .obtained:
                                print("👍 已同意")
                            default:
                                print("❓ 未知状态")
                            }
                        }
                    }
                    
                }
                
            } else {
                // 没有可展示的表单，也打印状态
                let status = ConsentInformation.shared.consentStatus
                switch status {
                case .required:
                    print("📌 需要同意（无可展示表单）")
                case .notRequired:
                    print("📌 不需要同意（无可展示表单）")
                case .obtained:
                    print("👍 已同意（无可展示表单）")
                default:
                    print("❓ 未知状态（无可展示表单）")
                }
            }
                    
        }
    }
    
    // ATT
    func requestPermission() {
        if #available(iOS 14, *) {
           // 4.GCD 主线程/子线程
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
              ATTrackingManager.requestTrackingAuthorization { status in
                  switch status {
                  case .authorized:
                      // Tracking authorization dialog was shown
                      // and we are authorized
                      print("Authorized")
                      // Now that we are authorized we can get the IDFA
                      print(ASIdentifierManager.shared().advertisingIdentifier)
                  case .denied:
                      // Tracking authorization dialog was
                      // shown and permission is denied
                      print("Denied")
                  case .notDetermined:
                      // Tracking authorization dialog has not been shown
                      print("Not Determined")
                  case .restricted:
                      print("Restricted")
                  @unknown default:
                      print("Unknown")
                  }
              }
           }
        }
    }
    
    func initmusic_block(){
        
                
        let vc = EoMusicVC.shared
        
        vc.view.backgroundColor = .bgroundColors
        
        vc.musicBlock = { [weak self] success, message in
            if success {
                self?.muisc_s_btn.isSelected = true
            } else {
                self?.muisc_s_btn.isSelected = false
            }
            self?.music_Label.text = message
        }
    }
    
    @objc func showmucis(){
        music_btn.isHidden = true
    }
    
    @objc func dismissmusic(){
        music_btn.isHidden = false
    }
    
    func setupMusicButton() {
        
        UIApplication.shared.currentKeyWindow?.addSubview(music_btn)
        music_btn.snp.makeConstraints { make in
            make.trailing.equalTo(0)
            make.bottom.equalTo(-(88 + 6))
            make.size.equalTo(CGSize(width: 178, height: 52))
        }
        
        music_btn.addSubview(muisccimage)
        muisccimage.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(2)
            make.size.equalTo(CGSize(width: 52, height: 52))
        }
        
        music_btn.addSubview(muisc_s_btn)
        muisc_s_btn.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.trailing.equalTo(-8)
            make.size.equalTo(CGSize(width: 32, height: 32))
        }
        
        music_btn.addSubview(music_Label)
        music_Label.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.leading.equalTo(50)
            make.trailing.equalTo(-40)
        }
        
        view.addSubview(pop_view)
        pop_view.snp.makeConstraints { make in
            make.top.equalTo(106)
            make.trailing.equalTo(-16)
            make.size.equalTo(CGSize(width: 115, height: 30))
        }
        
        pop_view.addSubview(music_name_Label)
        music_name_Label.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.leading.equalTo(0)
            make.size.equalTo(CGSize(width: 87, height: 30))
        }
        
        pop_view.addSubview(muisic_close_btn)
        muisic_close_btn.snp.makeConstraints { make in
            make.top.equalTo(5)
            make.leading.equalTo(music_name_Label.snp.trailing)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        
        
    }
    
    
    @objc func handleMusicCloseSender(){
        pop_view.isHidden = true
        file_path = URL(fileURLWithPath: "")
    }
    
    @objc func handleMusicPlaySender(){
        
        EoMusicVC.shared.handlePlaySender()
    
    }
    
    @objc func handleMusicSender(){
        
        let vc = EoMusicVC.shared
        music_btn.isHidden = true
        vc.musicBlock = { [weak self] success, message in
            if success {
                self?.muisc_s_btn.isSelected = true
            } else {
                self?.muisc_s_btn.isSelected = false
            }
            self?.music_Label.text = message
        }
      
        if let topVC = UIApplication.topViewController {
            print("当前顶层 VC: \(topVC)")
            
            topVC.navigationController?.pushViewController(vc, animated: true)
        }
                
    }
    
    private func configUI () {
        
        navBar.barBackgroundColor = .bgroundColors
        
        self.view.addSubview(topimageV)
        topimageV.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(0)
            make.height.equalTo(234)
        }

        self.view.addSubview(titleimage)
        titleimage.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(NAVIGATION_H + 11)
            make.size.equalTo(CGSize(width: 82, height: 28))
        }
                
        getTableView()
        
        tableview?.snp.makeConstraints({ make in
            make.top.equalTo(NAVIGATION_H + 11 + 28 + 8)
            make.bottom.leading.trailing.equalTo(0)
        })
        
        let headerView = EoHomeheaderView().loadViewFromNib()
        headerView.frame = CGRectMake(0, 0, WSCREEN, 710 + NAVIGATION_H + STATUS_H)
        tableview?.tableHeaderView = headerView;
            
        headerView.presentBlocks = { [weak self] in
            let vc = EoRecordVC()
            vc.saveBlock = { [weak self] file_name in
                Eo_Log("file_name=\(file_name)")
                self?.file_path = file_name
                self?.pop_view.isHidden = false
                self?.music_name_Label.text = file_name.deletingPathExtension().lastPathComponent
            }
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
        }
        
        headerView.nextBlocks = { [weak self] indexs in
//            let numbers = [0]
//            let _ = numbers[1]
            
            if  self?.pop_view.isHidden == true {
                self?.showToast(text: "Please add the music first")
            } else {
                GADInterstitialAdManager.share.adDidCloseHandler = { [weak self] in
                    
                    let vc = EoEditRecordVC()
                    vc.music_path = self?.file_path
                    if indexs != -1 {
                        vc.bg_name = "eo_music_bg_" + "\(indexs)"
                    }
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                GADInterstitialAdManager.share.showAdIfAvailable(from: self ?? UIViewController())
            }
        }
        
        headerView.presentUploadBlocks = { [weak self] in
            self?.uploadFileTapped()
        }
        
        setupMusicButton()
    
    }
    
    
    // 文件上传
    func uploadFileTapped() {
        // 支持选择任意类型文件
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.audio], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    
    // MARK: - UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let pickedURL = urls.first else { return }
        saveFileToLocal(pickedURL: pickedURL)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("用户取消选择文件")
    }
    
    // MARK: - 保存文件到本地
    private func saveFileToLocal(pickedURL: URL) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsURL.appendingPathComponent(pickedURL.lastPathComponent)
        
        do {
            // 如果同名文件存在，先删除
            if fileManager.fileExists(atPath: destinationURL.path) {
                try fileManager.removeItem(at: destinationURL)
            }
            
            // 复制文件到 App 沙盒
            try fileManager.copyItem(at: pickedURL, to: destinationURL)
            file_path = destinationURL
            pop_view.isHidden = false
            music_name_Label.text = destinationURL.deletingPathExtension().lastPathComponent
            print("文件已保存到本地: \(destinationURL.path)")
            
        } catch {
            print("保存文件失败: \(error.localizedDescription)")
        }
    }

}

