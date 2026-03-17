//
//  PopupManager2.swift
//
//

import Foundation
import UIKit
import SnapKit

enum EoPopupDirection {
    case center
    case bottom
}

class EoPopupManager: NSObject {

    static let shared = EoPopupManager()
    
    private lazy var maskHudView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hexString: "#000000", alpha: 0.5)
        v.isUserInteractionEnabled = true
        return v
    }()
    
    override init() { }

    var popupView: UIView? = nil

    func showPopupView(_ popupView: UIView, direction: EoPopupDirection, addTo view: UIView? = nil) {
        self.popupView = popupView
        let superView = view ?? UIApplication.shared.currentKeyWindow
        superView?.addSubview(maskHudView)
        
        maskHudView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        maskHudView.addSubview(popupView)
        popupView.translatesAutoresizingMaskIntoConstraints = false
        
        switch direction {
        case .center:
            popupView.alpha = 0.0
            popupView.layer.cornerRadius = 10.0
            popupView.layer.masksToBounds = true
            popupView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.center.equalToSuperview()
                make.size.equalTo(CGSize(width: popupView.frame.width, height: popupView.frame.height))
            }
            maskHudView.layoutIfNeeded()
            break
        case .bottom:
            popupView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.bottom.equalToSuperview().offset(popupView.frame.height)
                make.size.equalTo(CGSize(width: popupView.frame.width, height: popupView.frame.height))
            }
            maskHudView.layoutIfNeeded()
        }
        
        switch direction {
        case .center:
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .transitionFlipFromRight], animations: {
                popupView.alpha = 1.0
            }, completion: nil)
        case .bottom:
            UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseInOut, .transitionCurlUp]) {
                popupView.snp.updateConstraints { make in
                    make.bottom.equalToSuperview()
                }
                self.maskHudView.layoutIfNeeded()
                self.setCorner()
            }
        }

        // 添加手势，点击空白处即消失
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        superView?.addGestureRecognizer(gestureRecognizer)

        // 禁用子视图的手势
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
    }
    
    private func setCorner() {
        guard let popupView = popupView else { return }
        let cornerPath = UIBezierPath.init(roundedRect: popupView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: .init(width: 16, height: 16))
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = popupView.bounds
        maskLayer.path = cornerPath.cgPath
        popupView.layer.mask = maskLayer
    }

    func dismissPopupView() {
        maskHudView.subviews.forEach { item in
            item.removeFromSuperview()
        }
        maskHudView.removeFromSuperview()
        popupView = nil
    }

    @objc
    func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let popupView = popupView else { return }

        let location = gestureRecognizer.location(in: gestureRecognizer.view)

        if !popupView.frame.contains(location) {
            dismissPopupView()
            gestureRecognizer.view?.removeGestureRecognizer(gestureRecognizer)
        }
    }
}

extension EoPopupManager: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let popupView = popupView else { return false }
        
        // 禁用点击弹窗内部时响应superView的手势
        let location = touch.location(in: gestureRecognizer.view)
        if popupView.frame.contains(location) {
            return false
        }
        
        return true
    }
}
