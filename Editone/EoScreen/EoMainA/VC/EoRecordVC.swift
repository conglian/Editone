//
//  EoRecordVC.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 18/03/2026.
//

import UIKit
import SnapKit

class EoRecordVC: BaseViewController {

    // fileprivate UI variable
    fileprivate lazy var topimageV : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "eo_top_bg")
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var topimageV2 : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "eo_lu_bg")
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
    fileprivate lazy var time_Label : UILabel = {
        let v = UILabel()
        v.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.6)
        v.font = UIFont.systemFont(ofSize: 14)
        v.textAlignment = .center
        v.text = "0:00:00"
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var tips_Label : UILabel = {
        let v = UILabel()
        v.textColor = UIColor(hexString: "#FFFFFF", alpha: 0.6)
        v.font = UIFont.systemFont(ofSize: 14)
        v.textAlignment = .center
        v.text = "Click The Start Button To Begin Recording"
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var start_btn : UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "eo_btn_bg"), for: .normal)
        v.setTitle("Start", for: .normal)
        v.setTitleColor(UIColor(named: "#0C0F14"), for: .normal)
        v.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        v.addTarget(self, action: #selector(handleStartSender), for: .touchUpInside)
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var stop_btn : UIButton = {
        let v = UIButton()
        v.setBackgroundImage(UIImage(named: "eo_lu_icon"), for: .normal)
        v.addTarget(self, action: #selector(handleStopSender), for: .touchUpInside)
        v.isHidden = true
        return v
    }()
    
    // fileprivate UI variable
    fileprivate lazy var proimage : UIImageView = {
        let v = UIImageView()
        v.image = UIImage(named: "eo_lu_pro")
        v.isHidden = true;
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        
        AudioManager.share.timeBlocks = { [weak self] in
            Eo_Log("\(AudioManager.share.currentRecordTime)")
            self?.time_Label.text = AudioManager.share.formatTime(AudioManager.share.currentRecordTime)
            
        }

    }
    
    @objc func handleStartSender(){
        print("开始录音")
        AudioManager.share.startRecording(fileNames: "name1111")
        start_btn.isHidden = true;
        tips_Label.isHidden = true;
        stop_btn.isHidden = false;
        proimage.isHidden = false;
    }
    
    @objc func handleStopSender(){
        print("停止录音")
        AudioManager.share.stopRecording()
        start_btn.isHidden = false;
        tips_Label.isHidden = false;
        stop_btn.isHidden = true;
        start_btn.setTitle("Re-Record", for: .normal)

    }
    
    private func configUI () {
        
        navBar.barBackgroundColor = .bgroundColors
        
        navBar.title = "Record"
                
        
        navBar.wr_setLeftButton(image: UIImage(named: "eo_close_btn")!)
        
        navBar.onClickLeftButton = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        self.view.addSubview(topimageV)
        topimageV.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(0)
            make.height.equalTo(421)
        }
        
        self.view.addSubview(topimageV2)
        topimageV2.snp.makeConstraints { make in
            make.top.equalTo(NAVIGATION_H)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(502)
        }
        
        self.view.addSubview(tips_Label)
        tips_Label.snp.makeConstraints { make in
            make.bottom.equalTo(-75)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(18)
        }
        
        self.view.addSubview(start_btn)
        start_btn.snp.makeConstraints { make in
            make.bottom.equalTo(-123)
            make.leading.equalTo(30)
            make.trailing.equalTo(-30)
            make.height.equalTo(50)
        }
        
        self.view.addSubview(proimage)
        proimage.snp.makeConstraints { make in
            make.bottom.equalTo(-216)
            make.leading.equalTo(11)
            make.trailing.equalTo(-11)
            make.height.equalTo(21)
        }
        
        self.view.addSubview(time_Label)
        time_Label.snp.makeConstraints { make in
            make.bottom.equalTo(-220)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(13)
        }
        
        self.view.addSubview(stop_btn)
        stop_btn.snp.makeConstraints { make in
            make.bottom.equalTo(-89)
            make.leading.equalTo((WSCREEN-106) * 0.5)
            make.height.width.equalTo(106)
        }
            
        
    }

}


