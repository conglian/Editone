//
//  BaseNavigationController.swift
//
//

import UIKit

class EoBaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        Eo_Log("push=\(viewControllers.count)"   )
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    //有导航栏的页面修改状态栏颜色
    override var childForStatusBarStyle: UIViewController?{
        return self.topViewController
    }
}
