//
//  EoMoreView.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 19/03/2026.
//

import UIKit

class EoMoreView: UIView {
    
    @IBOutlet weak var bottomView: UIView!
    
    func loadViewFromNib() -> EoMoreView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EoMoreView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! EoMoreView
        return view
    }
    
    var deleteBlock : (() ->Void)?
    
    var addtoLitsBlock : (() ->Void)?
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
                
        // 设置圆角半径
        bottomView.layer.cornerRadius = 24

        // 指定只对顶部左右生效
        bottomView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }

    @IBAction func handleCloseSender(_ sender: Any) {
        EoPopupManager.shared.dismissPopupView()
    }
    
    @IBAction func handleDeleteSender(_ sender: Any) {
        if deleteBlock != nil {
            deleteBlock!()
        }
        EoPopupManager.shared.dismissPopupView()
    }
    
    @IBAction func handleAddSender(_ sender: Any) {
        EoPopupManager.shared.dismissPopupView()
        if addtoLitsBlock != nil {
            addtoLitsBlock!()
        }
    }
}
