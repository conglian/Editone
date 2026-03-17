//
//  EoHomeViewController.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 17/03/2026.
//

import UIKit
import SnapKit

class EoHomeViewController: BaseViewController {
    
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
            make.size.equalTo(CGSize(width: 82, height: 28))
        }
                
        getTableView()
        
        tableview?.snp.makeConstraints({ make in
            make.top.equalTo(NAVIGATION_H + 11 + 28 + 8)
            make.bottom.leading.trailing.equalTo(0)
        })
        
        let headerView = EoHomeheaderView().loadViewFromNib()
        headerView.frame = CGRectMake(0, 0, WSCREEN, 660 + NAVIGATION_H + STATUS_H)
        tableview?.tableHeaderView = headerView;
            
        
    }

}
