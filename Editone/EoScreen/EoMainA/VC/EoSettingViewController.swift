//
//  EoSettingViewController.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 17/03/2026.
//

import UIKit
import SnapKit

class EoSettingViewController: BaseViewController {
    
    let cellID = "EoSettingViewCell"
    
    let datas = ["Privacy Agreement", "Terms Of Users", "Feedback"]
    
    let images = ["eo_privacy_icon", "eo_Terms_icon", "eo_feedback_icon"]
    
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
        v.image = UIImage(named: "eo_setting_title")
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()

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
            make.size.equalTo(CGSize(width: 93, height: 28))
        }
                
        getTableView()
        
        tableview?.register(UINib(nibName: cellID, bundle: Bundle(identifier: cellID)), forCellReuseIdentifier: cellID)
        tableview?.snp.makeConstraints({ make in
            make.top.equalTo(NAVIGATION_H + 11 + 28 + 8)
            make.bottom.leading.trailing.equalTo(0)
        })
    
            
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EoSettingViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)  as! EoSettingViewCell
        Eo_Log("1111")
        cell.selectionStyle = .none
        cell.titleLabel.text = datas[indexPath.row]
        cell.imageV.image = UIImage(named: images[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
