//
//  UIViewControllerExt.swift
//
//

import UIKit
import MBProgressHUD
import Toast_Swift

extension UIViewController {
    
    class func loadFromSB(name: String = "Main") -> Self {
        let sb = UIStoryboard(name: name, bundle: .main)
        let vc = sb.instantiateViewController(withIdentifier: "\(self)") as! Self
        return vc
    }
    
    /// Alert
    func showAlert(_ title: String? = nil,
                    message: String?,
                    actions: [String: UIAlertAction.Style] = [:],
                    handler: ((UIAlertAction) -> Void)? = nil,
                    textFields: [((UITextField) -> Void)] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if actions.isEmpty {
            alert.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            for action in actions {
                alert.addAction(UIAlertAction(title: action.key, style: action.value, handler: handler))
            }
        }
        for textField in textFields {
            alert.addTextField(configurationHandler: textField)
        }
        present(alert, animated: true)
    }
    
    func showActionSheet(title: String?, message: String?, actions: [(title: String, handler: ((UIAlertAction) -> Void)?, style: UIAlertAction.Style)]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        // 添加按钮
        for action in actions {
            let alertAction = UIAlertAction(title: action.title, style: action.style, handler: action.handler)
            alertController.addAction(alertAction)
        }
        
        // 添加取消按钮
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // 显示 ActionSheet
        present(alertController, animated: true, completion: nil)
    }
    
    func showLoading(onScreen: Bool = false) {
        if onScreen {
            let parentView = (UIApplication.shared.currentKeyWindow ?? UIView()) as UIView
            let hud = MBProgressHUD.showAdded(to: parentView, animated: true)
            hud.mode = .indeterminate
            hud.isUserInteractionEnabled = false // ⚡️允许下层点击
        } else {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .indeterminate
            hud.isUserInteractionEnabled = false // ⚡️允许下层点击
        }
    }
    
    func hiddeLoading(onScreen: Bool = false) {
        if onScreen {
            let parentView = (UIApplication.shared.currentKeyWindow ?? UIView()) as UIView
            MBProgressHUD.hide(for: parentView, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

}

extension UIApplication {
    
    /// 获取当前最顶层可见的 UIViewController
    static var topViewController: UIViewController? {
        // 获取 keyWindow（iOS 13+ 需要遍历 scenes）
        let windows = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .filter { $0.isHidden == false && $0.windowLevel == .normal }

        guard let rootVC = windows.first?.rootViewController else { return nil }

        return getTopViewController(from: rootVC)
    }

    private static func getTopViewController(from vc: UIViewController) -> UIViewController {
        // 1️⃣ modal 展示优先
        if let presented = vc.presentedViewController {
            return getTopViewController(from: presented)
        }
        
        // 2️⃣ UINavigationController
        if let nav = vc as? UINavigationController, let top = nav.topViewController {
            return getTopViewController(from: top)
        }
        
        // 3️⃣ UITabBarController
        if let tab = vc as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(from: selected)
        }
        
        // 4️⃣ 自定义 TabBarController
        if let customTab = vc as? EoCustomTabBarController {
            // 获取当前选中的 UINavigationController
            if customTab.viewControllersList.indices.contains(customTab.selectedIndex) {
                let currentNav = customTab.viewControllersList[customTab.selectedIndex]
                return getTopViewController(from: currentNav)
            }
        }
        
        // 5️⃣ 普通 UIViewController
        return vc
    }
}
