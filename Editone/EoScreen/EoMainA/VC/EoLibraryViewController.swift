//
//  EoLibraryViewController.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 17/03/2026.
//

import UIKit
import SnapKit

class EoLibraryViewController: BaseViewController {
    
    let cellID = "EoLibraryViewCell"
    
    var libs = [URL]()
    
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
        v.image = UIImage(named: "eo_lib_title")
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        libs = LibraryPlayListFileManager.shared.allSubdirectoriesSortedByCreationDateDesc()
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
            make.size.equalTo(CGSize(width: 81, height: 28))
        }
                
        getTableView()
        
        tableview?.register(UINib(nibName: cellID, bundle: Bundle(identifier: cellID)), forCellReuseIdentifier: cellID)
        
        tableview?.snp.makeConstraints({ make in
            make.top.equalTo(NAVIGATION_H + 11 + 28 + 8)
            make.leading.trailing.equalTo(0)
            make.bottom.equalTo(-88)
        })
        
        let headerView = EoLibraryheaderView().loadViewFromNib()
        headerView.frame = CGRectMake(0, 0, WSCREEN, 310 + NAVIGATION_H + STATUS_H)
        tableview?.tableHeaderView = headerView;
        
        headerView.workBlocks = { [weak self] in
            let vc = EoPlayListVC()
            vc.titles = "Playlist"
            vc.updateData(is_work: true, libs: [URL]())
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        // 创建新的歌单
        headerView.addNewBlocks = { [weak self] in
            let view = EoEditNameView().loadViewFromNib()
            view.nameTF.placeholder = "Playlist Name"
            view.saveBlock = {[weak self] name in
                LibraryPlayListFileManager.shared.createSubdirectory(name: name)
                self?.libs = LibraryPlayListFileManager.shared.allSubdirectoriesSortedByCreationDateDesc()
                self?.tableview?.reloadData()
            }
            EoPopupManager.shared.showPopupView(view, direction: .center)
            
        }
            
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return libs.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EoLibraryViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)  as! EoLibraryViewCell
        cell.selectionStyle = .none
        cell.lib_tilte_label.text = libs[indexPath.row].deletingPathExtension().lastPathComponent
        cell.btnsBlock = { [weak self] in
            LibraryPlayListFileManager.shared.deleteSubdirectory(name: self?.libs[indexPath.row].deletingPathExtension().lastPathComponent ?? "")
            self?.libs = LibraryPlayListFileManager.shared.allSubdirectoriesSortedByCreationDateDesc()
            self?.tableview?.reloadData()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EoPlayListVC()
        vc.titles = libs[indexPath.row].deletingPathExtension().lastPathComponent
        vc.updateData(is_work: false, libs: LibraryPlayListFileManager.shared.allFiles(inSubdirectory: libs[indexPath.row].deletingPathExtension().lastPathComponent))
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
