//
//  EoEditRecordVC.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 19/03/2026.
//

import UIKit
import SnapKit

class EoEditRecordVC: BaseViewController {
    
    // MARK: - UI Elements
    fileprivate lazy var topimageV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "eo_top_bg")
        return v
    }()
    
    fileprivate lazy var addimageV: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.image = UIImage(named: "eo_add_big")
        return v
    }()
    
    fileprivate lazy var add_Label: UILabel = {
        let v = UILabel()
        v.textColor = UIColor.init(hexString: "#FFFFFF", alpha: 0.6)
        v.textAlignment = .center
        v.font = UIFont.systemFont(ofSize: 16)
        v.text = "Add Cover"
        return v
    }()
    
    fileprivate lazy var music_name_Label: UILabel = {
        let v = UILabel()
        v.textColor = UIColor.init(hexString: "#FFFFFF")
        v.textAlignment = .left
        v.font = UIFont.systemFont(ofSize: 16)
        v.text = "Music Name"
        return v
    }()
    
    fileprivate lazy var edit_btn: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(handleEditSender), for: .touchUpInside)
        v.setImage(UIImage(named: "eo_edit_icon_s"), for: .normal)
        return v
    }()
    
    fileprivate lazy var add_bg_btn: UIButton = {
        let v = UIButton()
        v.addTarget(self, action: #selector(handleAddSender), for: .touchUpInside)
        v.backgroundColor = UIColor.init(hexString: "#99ADCB", alpha: 0.12)
        // 设置圆角
        v.layer.cornerRadius = 21
        v.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效
        // 设置边线
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.init(hexString: "#FFFFFF", alpha: 0.05).cgColor
        return v
    }()
    
    
    @objc func handleAddSender(){
        Eo_Log("handleAddSender")
    }
    
    
    @objc func handleEditSender(){
        Eo_Log("handleEditSender")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    // MARK: - UI Setup
    private func configUI() {
        
        navBar.barBackgroundColor = .bgroundColors
        
        
        navBar.title = "Record"
        
        view.addSubview(topimageV)
        topimageV.snp.makeConstraints { make in
            make.leading.top.trailing.equalTo(0)
            make.height.equalTo(421)
        }
        
        view.addSubview(add_bg_btn)
        add_bg_btn.snp.makeConstraints { make in
            make.top.equalTo(NAVIGATION_H + 40)
            make.leading.equalTo((WSCREEN - 242) * 0.5)
            make.height.width.equalTo(242)
        }
        
        add_bg_btn.addSubview(addimageV)
        addimageV.snp.makeConstraints { make in
            make.top.equalTo(54)
            make.leading.equalTo(76)
            make.height.width.equalTo(90)
        }
        
        add_bg_btn.addSubview(add_Label)
        add_Label.snp.makeConstraints { make in
            make.top.equalTo(164)
            make.leading.trailing.equalTo(0)
            make.height.equalTo(24)
            make.width.equalToSuperview()
        }
        
        view.addSubview(edit_btn)
        edit_btn.snp.makeConstraints { make in
            make.top.equalTo(add_bg_btn.snp.bottom).offset(64)
            make.centerX.equalTo(view.snp.centerX).offset(-40)
            make.height.width.equalTo(38)
        }
        
        view.addSubview(music_name_Label)
        music_name_Label.snp.makeConstraints { make in
            make.top.equalTo(add_bg_btn.snp.bottom).offset(71)
            make.trailing.equalTo(edit_btn.snp.trailing).offset(-8)
            make.height.equalTo(24)
        }
        
    }
    

    

}
