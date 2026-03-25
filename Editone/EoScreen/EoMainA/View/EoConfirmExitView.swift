//
//  EoConfirmExitView.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 20/03/2026.
//

import UIKit

class EoConfirmExitView: UIView {
    
    var exitBlcok : (() -> Void)?
    
    func loadViewFromNib() -> EoConfirmExitView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EoConfirmExitView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! EoConfirmExitView
        return view
    }

    @IBAction func handleCloseSender(_ sender: Any) {
        EoPopupManager.shared.dismissPopupView()
    }
    
    @IBAction func handleExitSender(_ sender: Any) {
        if exitBlcok != nil {
            exitBlcok!()
        }
        EoPopupManager.shared.dismissPopupView()
    }
    
    @IBAction func handleCancelSender(_ sender: Any) {
        EoPopupManager.shared.dismissPopupView()
    }
}
