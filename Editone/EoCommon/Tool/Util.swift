//
//  Util.swift
//
//

import Foundation
import UIKit

class Util {
    
    //从date开始有多少天
    class func daysFromToday(_ date: Date) -> Int {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())
        let endDate = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        guard let days = components.day else { return 0 }
        return days
    }
    
    /// 计算行数
    class func calculateRowCount(cloum: Int = 3, n: Int) -> Int {
        let row = n / cloum
        let remainder = n % cloum
        if remainder == 0 {
            return row
        } else {
            return row + 1
        }
    }
    
    /// 是否是以1开头的整数
    /// - Parameter number: 整数
    /// - Returns: 结果
    class func isStartingWithOne(_ number: Int) -> Bool {
        guard number >= 0 else { return false }
        let firstDigit = Int(String(String(number).first!))
        return firstDigit == 1
    }
    /// data->dict
    class func dataToDictionary(data:Data) ->Dictionary<String, Any>?{
        
        do{

            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)

            let dic = json as! Dictionary<String, Any>

            return dic

        }catch _ {

            print("失败")

            return nil

        }

    }
    

}
/// 抖动方向
///
/// - horizontal: 水平抖动
/// - vertical:   垂直抖动
public enum ZHYShakeDirection: Int {
    case horizontal
    case vertical
}
extension UIView {
    
    public func shake(direction: ZHYShakeDirection = .horizontal, times: Int = 5, interval: TimeInterval = 0.1, offset: CGFloat = 2, completion: (() -> Void)? = nil) {
           
           //移动视图动画（一次）
           UIView.animate(withDuration: interval, animations: {
               switch direction {
                   case .horizontal:
                       self.layer.setAffineTransform(CGAffineTransform(translationX: offset, y: 0))
                   case .vertical:
                       self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: offset))
               }
               
           }) { (complete) in
               //如果当前是最后一次抖动，则将位置还原，并调用完成回调函数
               if (times == 0) {
                   UIView.animate(withDuration: interval, animations: {
                       self.layer.setAffineTransform(CGAffineTransform.identity)
                   }, completion: { (complete) in
                       completion?()
                   })
               }
               
               //如果当前不是最后一次，则继续动画，偏移位置相反
               else {
                   self.shake(direction: direction, times: times - 1, interval: interval, offset: -offset, completion: completion)
               }
           }
       }
}
