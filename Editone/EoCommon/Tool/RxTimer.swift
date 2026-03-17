//
//  RxTimer.swift
//
//

import Foundation
import RxSwift
import RxCocoa

class RxTimer {
    
    private var timer: Observable<Int>?
    
    private var disposeBag = DisposeBag()
    
    private let pauseSubject = PublishSubject<Void>()
    
    private var remainingTime: Int = 0
    
    private var isPaused = true
    
    init(interval: TimeInterval) {
        self.timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .take(until: pauseSubject)
            .subscribe(onNext: { _ in
                self.remainingTime += 1
            }) as? Observable<Int>
    }
    
    func start(seconds: Int, completion: (() -> Void)? = nil) {
        self.remainingTime = 0
        self.isPaused = false
        if let completion = completion {
            self.timer?.subscribe(onCompleted: { completion() }).disposed(by: disposeBag)
        }
    }
    
    func pause() {
        self.isPaused = true
        self.disposeBag = DisposeBag()
    }
    
    func restart() {
        if self.isPaused {
            self.isPaused = false
            self.timer?.subscribe().disposed(by: disposeBag)
        }
    }
    
    func stop() {
        self.remainingTime = 0
        self.pauseSubject.onNext(())
        self.disposeBag = DisposeBag()
    }
    
    func currentTime() -> Int {
        return remainingTime
    }
    
    func subscribe(onNext: @escaping (Int) -> Void) {
        timer?
            .map { remainingTime in
                return self.remainingTime
            }
            .subscribe(onNext: { time in
                onNext(time)
            })
            .disposed(by: disposeBag)
    }
    
}
