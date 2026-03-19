//
//  EoPlayListVC.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 18/03/2026.
//

import UIKit
import SnapKit
import LYEmptyView

class EoPlayListVC: BaseViewController {
    
    var titles = "Playlist"
    
    let cellID = "EoLibraryViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        
    }
    
    private func configUI () {
        
        navBar.barBackgroundColor = .bgroundColors
        
        navBar.title = titles;
        
        getTableView()
        
        tableview?.register(UINib(nibName: cellID, bundle: Bundle(identifier: cellID)), forCellReuseIdentifier: cellID)
        
        tableview?.snp.makeConstraints({ make in
            make.top.equalTo(NAVIGATION_H)
            make.bottom.leading.trailing.equalTo(0)
        })
        
        tableview?.ly_emptyView = BPEmptyView.empty(withImageStr: "eo_not_icon", titleStr: "", detailStr: "No Content")

        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EoLibraryViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)  as! EoLibraryViewCell
        cell.selectionStyle = .none
        cell.iconimage.image = UIImage(named: "eo_more_icon")
        cell.btnsBlock = { [weak self] in
            EoPopupManager.shared.showPopupView(EoMoreView().loadViewFromNib(), direction: .center)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EoPlayListVC()
        vc.titles = "Playlist2"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
