//
//  UIImageExt.swift
//
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func setImage(url: String?, placeHolder: UIImage? = nil, compltion: ((UIImage) -> Void)? = nil) {
        let options: KingfisherOptionsInfo = [
            .onFailureImage(placeHolder)
        ]
        if let url = url, let imageUrl = URL(string: url) {
            self.kf.setImage(with: imageUrl, placeholder: placeHolder, options: options) { result in
                switch result {
                case .success(let result):
                    let img = result.image
                    compltion?(img)
                default:
                    break
                }
            }
        } else {
            self.image = placeHolder
        }
    }
}

extension UIImage {
    func stretchMiddle() -> UIImage? {
        let capInsets = UIEdgeInsets(top: size.height / 2, left: size.width / 2, bottom: size.height / 2, right: size.width / 2)
        return resizableImage(withCapInsets: capInsets, resizingMode: .stretch)
    }
}
