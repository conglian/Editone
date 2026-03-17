//
//  UISliderExt.swift
//
//

import UIKit

extension UISlider {
    var thumbCenterX: CGFloat {
        return thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value).midX
    }
}
