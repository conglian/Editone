//
//  UICollectionView+MJ.swift
//
//

import UIKit
import MJRefresh

extension UICollectionView {
    
    // 添加下拉刷新功能
    func addPullToRefresh(action: @escaping () -> Void) {
        let header = MJRefreshNormalHeader(refreshingBlock: {
            action()
        })
        self.mj_header = header
    }
    
    // 添加加载更多功能
    func addLoadMore(action: @escaping () -> Void) {
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            action()
        })
        self.mj_footer = footer
    }
    
    // 结束下拉刷新
    func endPullToRefresh() {
        self.mj_header?.endRefreshing()
    }
    
    // 结束加载更多
    func endLoadMore() {
        self.mj_footer?.endRefreshing()
    }
    
    // 设置是否还有更多数据
    func setNoMoreData(_ noMoreData: Bool) {
        self.mj_footer?.endRefreshingWithNoMoreData()
    }
    
    // 重置加载更多状态
    func resetLoadMore() {
        self.mj_footer?.resetNoMoreData()
    }
}
