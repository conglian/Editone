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

    
    static var current: UIViewController? {
        var rootVC: UIViewController?
        
        if #available(iOS 13.0, *) {
            rootVC = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })?
                .rootViewController
        } else {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        var current = rootVC
        // 处理被 present 的 VC
        while let presented = current?.presentedViewController {
            current = presented
        }
        // 处理 TabBarController
        if let tabbar = current as? UITabBarController,
           let selected = tabbar.selectedViewController {
            current = selected
        }
        // 处理 NavigationController
        while let nav = current as? UINavigationController,
              let top = nav.topViewController {
            current = top
        }
        
        return current
    }
    
    func showLoading(onScreen: Bool = true) {
        if onScreen {
            let parentView = (UIApplication.shared.currentKeyWindow ?? UIView()) as UIView
            MBProgressHUD.showAdded(to: parentView, animated: true)
        } else {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    func hiddeLoading(onScreen: Bool = true) {
        if onScreen {
            let parentView = (UIApplication.shared.currentKeyWindow ?? UIView()) as UIView
            MBProgressHUD.hide(for: parentView, animated: true)
        } else {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

}
