//
//  EoLibraryheaderView.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 17/03/2026.
//

import UIKit

class EoLibraryheaderView: UIView {
    
    var workBlocks : (() -> Void)?
    
    var addNewBlocks : (() -> Void)?
    
    func loadViewFromNib() -> EoLibraryheaderView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EoLibraryheaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! EoLibraryheaderView
        return view
    }

    @IBAction func handleWorkSender(_ sender: Any) {
        Eo_Log("handleWorkSender")
        if workBlocks != nil {
            workBlocks!()
        }
    }
    
    @IBAction func handleAddNewSender(_ sender: Any) {
        Eo_Log("handleAddNewSender")
        if addNewBlocks != nil {
            addNewBlocks!()
        }
    }
}
