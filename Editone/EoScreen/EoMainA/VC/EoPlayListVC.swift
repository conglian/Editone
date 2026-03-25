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
    
    var liburls : [URL] = [URL]()
    
    var is_worklist = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configUI()
        
    }
    
    func updateData(is_work : Bool, libs : [URL]){
        if is_work {
            liburls = LibraryFileManager.shared.allFileURLs()
            self.tableview?.reloadData()
        } else {
            is_worklist = false
            liburls = libs
            self.tableview?.reloadData()
        }
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
        return liburls.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EoLibraryViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)  as! EoLibraryViewCell
        cell.selectionStyle = .none
        cell.iconimage.image = UIImage(named: "eo_more_icon")
        cell.lib_tilte_label.text = "\(liburls[indexPath.row].deletingPathExtension().lastPathComponent)"
        cell.btnsBlock = { [weak self] in
            let view = EoMoreView().loadViewFromNib()
            view.deleteBlock = { [weak self] in
                if self?.is_worklist == true {
                    LibraryFileManager.shared.deleteFile(nameWithoutExtension: "\(self?.liburls[indexPath.row].deletingPathExtension().lastPathComponent ?? "")")
                    self?.showToast(text: "Deletion successful")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        // 这里的代码将在主线程执行
                        self?.liburls = LibraryFileManager.shared.allFileURLs()
                        self?.tableview?.reloadData()
                    }
                } else {
                    // 子目录删除操作
                    LibraryPlayListFileManager.shared.deleteFile(inSubdirectory: self?.navBar.title ?? "", fileName: "\(self?.liburls[indexPath.row].deletingPathExtension().lastPathComponent ?? "")")
                    self?.showToast(text: "Deletion successful")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        // 这里的代码将在主线程执行
                        self?.liburls = LibraryPlayListFileManager.shared.allFiles(inSubdirectory: self?.navBar.title ?? "")
                        self?.tableview?.reloadData()
                    }
                }
            }
            view.addtoLitsBlock = { [weak self] in
                let views = EoAddToPlaylistView().loadViewFromNib()
                views.music_name = "\(self?.liburls[indexPath.row].deletingPathExtension().lastPathComponent ?? "")"
                views.music_url = self?.liburls[indexPath.row] ?? URL(fileURLWithPath: "")
                EoPopupManager.shared.showPopupView(views, direction: .bottom)
            }
            EoPopupManager.shared.showPopupView(view, direction: .center)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.is_worklist == true {
            let vc = EoMusicVC.shared
            vc.current_name = "\(liburls[indexPath.row].deletingPathExtension().lastPathComponent)"
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = EoMusicVC.shared
            vc.current_name = "\(liburls[indexPath.row].deletingPathExtension().lastPathComponent)"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
