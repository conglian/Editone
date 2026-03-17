//
//  UICollectionViewExt.swift
//
//

import Foundation
import UIKit

extension UICollectionView {
    
    /// 获取中心点
    var centerPoint : CGPoint {
        get {
            return CGPoint(x: self.center.x + self.contentOffset.x, y: self.center.y + self.contentOffset.y);
        }
    }
    
    /// 根据中心点获取中心点所在的IndexPath
    var centerCellIndexPath: IndexPath? {
        if let centerIndexPath = self.indexPathForItem(at: self.centerPoint) {
            return centerIndexPath
        }
        return nil
    }
    
    /// UICollectionView滑动到底部
    func scrollToBottom() {
        self.layoutIfNeeded()
        DispatchQueue.main.async {
            self.scrollRectToVisible(CGRect(x: self.contentSize.width - 1, y: self.contentSize.height - 1, width: 1, height: 1), animated: false)
        }
    }
    
    /// UICollectionView滑动到顶部
    func scrollToTop() {
        self.layoutIfNeeded()
        DispatchQueue.main.async {
            self.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        }
    }
}
