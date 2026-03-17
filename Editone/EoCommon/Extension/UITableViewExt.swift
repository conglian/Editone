//
//  UITableViewExt.swift
//
//

import Foundation
import UIKit

extension UITableView {
    
    /// UITableView滑动到底部
    func scrollToBottom() {
        self.layoutIfNeeded()
        DispatchQueue.main.async {
            self.scrollRectToVisible(CGRect(x: self.contentSize.width - 1, y: self.contentSize.height - 1, width: 1, height: 1), animated: false)
        }
    }
    
}

/// section 添加圆角
extension UITableViewCell {
    
    private func _tableView() -> UITableView? {
        if let tableView = self.superview as? UITableView {
            return tableView
        }
        if let tableView = self.superview?.superview as? UITableView {
            return tableView
        }
        return nil
    }
    
    func addSectionCorner(at indexPath: IndexPath, radius: CGFloat = 10) {
        let tableView = self._tableView()!
        let rows = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == 0 || indexPath.row == rows - 1 {
            var corner: UIRectCorner
            if rows == 1 {
                corner = UIRectCorner.allCorners
            }else if indexPath.row == 0 {
                let cornerRawValue = UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue
                corner = UIRectCorner(rawValue: cornerRawValue)
            }else {
                let cornerRawValue = UIRectCorner.bottomLeft.rawValue | UIRectCorner.bottomRight.rawValue
                corner = UIRectCorner(rawValue: cornerRawValue)
            }
            let cornerLayer = CAShapeLayer()
            cornerLayer.masksToBounds = true
            cornerLayer.frame = self.bounds
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corner, cornerRadii: CGSize(width: radius, height: radius))
            cornerLayer.path = path.cgPath
            self.layer.mask = cornerLayer
        } else {
            self.layer.mask = nil
        }
    }
}
