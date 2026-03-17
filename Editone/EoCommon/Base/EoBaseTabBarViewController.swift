//
//  EoCustomTabBarController.swift
//  PulseFit
//
//  Created by ECHELON MATRIX ENTERPRISES on 16/03/2026.
//

import UIKit
import AxcAE_TabBar
import SnapKit

class EoCustomTabBarController: UITabBarController {
    
    // MARK: - Properties
    var axcTabBar = AxcAE_TabBar()
    
    let selectedImageArr = ["eo_home_s", "eo_Library_s", "eo_set_s"]
    
    let normalImageArr = ["eo_home_n", "eo_Library_n", "eo_set_n"]
    
    let titleArr = ["Create", "Library", "Setting"]
    
    var tabBarVCs = [EoBaseNavigationController]()
    
    var currentIndex: Int = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        setupAxcTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        axcTabBar.translatesAutoresizingMaskIntoConstraints = false
        axcTabBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(88)
        }
        self.axcTabBar.viewDidLayoutItems();
        
    }
    
    // MARK: - Setup ViewControllers
    private func setupViewControllers() {
        let homeVC = EoBaseNavigationController(rootViewController: EoHomeViewController())
        let libraryVC = EoBaseNavigationController(rootViewController: EoLibraryViewController())
        let settingVC = EoBaseNavigationController(rootViewController: EoSettingViewController())
        tabBarVCs = [homeVC, libraryVC, settingVC]
    }
    
    // MARK: - Setup AxcAE_TabBar
    private func setupAxcTabBar() {
        var models = [AxcAE_TabBarConfigModel]()
        for (index, _) in tabBarVCs.enumerated() {
            let model = AxcAE_TabBarConfigModel()
            model.bulgeStyle = .normal
            model.selectImageName = selectedImageArr[index]
            model.normalImageName = normalImageArr[index]
            model.itemTitle = titleArr[index]
            model.itemSize = CGSize(width: UIScreen.main.bounds.width / CGFloat(tabBarVCs.count), height: 88)
            model.interactionEffectStyle = .spring
            model.componentMargin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            model.pictureWordsMargin = -10
            models.append(model)
        }
        self.viewControllers = tabBarVCs;
        axcTabBar.tabBarConfig = models
        axcTabBar.delegate = self
        axcTabBar.backgroundColor = .tabbarbgroundColors
        view.addSubview(axcTabBar)
        
        // AutoLayout
        axcTabBar.translatesAutoresizingMaskIntoConstraints = false
        axcTabBar.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(88)
        }
    
    }
    
    
}
extension EoCustomTabBarController: AxcAE_TabBarDelegate {
    
    func axcAE_TabBar(_ tabbar: AxcAE_TabBar!, select index: Int) {
        self.selectedIndex = index
        if self.axcTabBar != nil {
            self.axcTabBar.selectIndex = index
        }
    }
    
    
}
