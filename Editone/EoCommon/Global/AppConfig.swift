//
//  AppConfig.swift
//

import UIKit

class AppConfig {
    
    class func bottomSafeAreaInset() -> CGFloat {
        return UIApplication.shared.currentKeyWindow?.safeAreaInsets.bottom ?? 20
    }
    
    class func topSafeAreaInset() -> CGFloat {
        return UIApplication.shared.currentKeyWindow?.safeAreaInsets.top ?? 20
    }
    
    class func statusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return 0 }
        guard let statusBarManager = windowScene.statusBarManager else { return 0 }
        statusBarHeight = statusBarManager.statusBarFrame.height
        return statusBarHeight
    }
}

struct Asyncs {
    public typealias Task = () -> Void

    public static func async(_ task: @escaping Task) {
        //传入全局任务
        _async(task)
    }

    public static func async(_ task: @escaping Task, _ mainTask: @escaping Task) {
        //传入全局任务，主队列任务
        _async(task, mainTask)
    }

    private static func _async(_ task: @escaping Task, _ mainTask: Task? = nil) {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().async(execute: item)

        //可选项绑定
        if let main = mainTask {
            //item⾥⾯的任务完成之后，再到主队列执⾏
            item.notify(queue: DispatchQueue.main, execute: main)
        }
    }
}
