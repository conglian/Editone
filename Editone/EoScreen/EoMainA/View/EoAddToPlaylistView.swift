//
//  EoAddToPlaylistView.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 19/03/2026.
//

import UIKit
import LYEmptyView
import SnapKit

class EoAddToPlaylistView: UIView , UITableViewDelegate, UITableViewDataSource {
    
    func loadViewFromNib() -> EoAddToPlaylistView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EoAddToPlaylistView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! EoAddToPlaylistView
        return view
    }
    
    var tableview : UITableView?
    
    let cellID = "EoLibraryViewCell"
    
    var seletecd_index = 0
    
    @IBOutlet weak var tableViewbg: UIView!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
                
        // 设置圆角半径
        self.layer.cornerRadius = 24

        // 指定只对顶部左右生效
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        getTableView()
        
    }
    
    func getTableView() {
        tableview = .init(frame: CGRectMake(0, 0, WSCREEN, HSCREEN), style: .plain)
        tableview?.delegate = self
        tableview?.dataSource = self
        tableview?.separatorStyle = .none
        tableview?.backgroundColor = UIColor.init(hexString: "#2F353E")
        tableview?.tableFooterView = UIView()
        tableview?.tableHeaderView = UIView()
        tableview?.ly_emptyView = BPEmptyView.empty(withImageStr: "", titleStr: "", detailStr: "")
        tableview?.ly_emptyView.tapEmptyViewBlock = {
            
        }
        tableViewbg.addSubview(tableview!)
        
        tableview?.register(UINib(nibName: cellID, bundle: Bundle(identifier: cellID)), forCellReuseIdentifier: cellID)
        
        tableview?.snp.makeConstraints({ make in
            make.top.bottom.leading.trailing.equalTo(0)
        })
    }
    
    
    @IBAction func handleCloseSender(_ sender: Any) {
        EoPopupManager.shared.dismissPopupView()
    }
    
    @IBAction func handleAddSender(_ sender: Any) {
        EoPopupManager.shared.dismissPopupView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EoLibraryViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)  as! EoLibraryViewCell
        cell.selectionStyle = .none
        if indexPath.row == self.seletecd_index {
            cell.iconimage.image = UIImage(named: "eo_dui_icon")
        } else {
            cell.iconimage.image = UIImage(named: "")
        }
        cell.contentView.backgroundColor = UIColor.init(hexString: "#2F353E")
        cell.centerView.backgroundColor = UIColor.init(hexString: "#202429")
        cell.btnsBlock = {}
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seletecd_index = indexPath.row
        self.tableview?.reloadData()
    }
    
}
