//
//  RxDownTimer.swift
//
//

import Foundation
import RxSwift
import RxCocoa

class RxDownTimer {
    
    /// 倒计时
    /// - Parameters:
    ///   - second: 倒计时的秒数
    ///   - immediately: 是否立即开始，ture即将立即开始倒计时，false将在1秒后开始倒计时
    ///   - duration: 倒计时的过程
    /// - Returns: 倒计时结束的通知
    class func countDown(second: Int,
                         immediately: Bool = true,
                         duration: ((Int) -> Void)?) -> Single<Void> {
        guard second > 0 else { return Single<Void>.just(()) }
        if immediately {
            duration?(second)
        }
        return Observable<Int>
            .interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .map {second - (immediately ? ($0 + 1) : $0) }
            .take(second + (immediately ? 0 : 1))
            .do(onNext: { (index) in
                duration?(index)
            }).filter({ return $0 == 0 })
                .map { _ in return ()}
                .asSingle()
    }
}
