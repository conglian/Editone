//
//  EoEditNameView.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 20/03/2026.
//

import UIKit

class EoEditNameView: UIView {
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var TFbgView: UIView!
    
    var saveBlock : ((String) -> Void)?
    
    func loadViewFromNib() -> EoEditNameView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EoEditNameView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! EoEditNameView
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        TFbgView.layer.borderWidth = 1
        TFbgView.layer.borderColor = UIColor.init(hexString: "#36393E").cgColor
        self.cornerRadius = 24
    }

    @IBAction func handleCloseSender(_ sender: Any) {
        EoPopupManager.shared.dismissPopupView()
    }
    
    @IBAction func handleSaveSender(_ sender: Any) {
        if nameTF.text?.count ?? 0 <= 0 {
            self.showToast(text:"Please enter your name.")
        } else {
            if nameTF.text?.count ?? 0 > 20 {
                self.showToast(text:"Name Exceeds The Maximum Range Of 20")
            } else {
                EoPopupManager.shared.dismissPopupView()
                if saveBlock != nil {
                    saveBlock!(nameTF.text ?? "Music Name")
                }
            }
        }
    }
    
}
