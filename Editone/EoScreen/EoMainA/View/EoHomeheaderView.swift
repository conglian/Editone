//
//  EoHomeheaderView.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 17/03/2026.
//

import UIKit

class EoHomeheaderView: UIView {
    
    func loadViewFromNib() -> EoHomeheaderView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EoHomeheaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! EoHomeheaderView
        return view
    }

    @IBAction func handleUploadSender(_ sender: Any) {
        Eo_Log("handleUploadSender")
    }
    
    @IBAction func handleRecordSender(_ sender: Any) {
        Eo_Log("handleRecordSender")
    }
    
    @IBAction func handleMusicTypeOneSender(_ sender: Any) {
        Eo_Log("handleMusicTypeOneSender")
    }
    
    @IBAction func handleMusicTypeTwoSender(_ sender: Any) {
        Eo_Log("handleMusicTypeTwoSender")
    }
    
    @IBAction func handleMusicTypeThreeSender(_ sender: Any) {
        Eo_Log("handleMusicTypeThreeSender")
    }
    
    @IBAction func handleMusicTypeFourSender(_ sender: Any) {
        Eo_Log("handleMusicTypeFourSender")
    }
    
    @IBAction func handleMusicTypeNextSender(_ sender: Any) {
        Eo_Log("handleMusicTypeNextSender")
    }
    
}
