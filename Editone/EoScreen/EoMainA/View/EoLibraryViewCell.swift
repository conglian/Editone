//
//  EoLibraryViewCell.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 17/03/2026.
//

import UIKit

class EoLibraryViewCell: UITableViewCell {
    
    @IBOutlet weak var lib_tilte_label: UILabel!
    
    @IBOutlet weak var iconimage: UIImageView!
    
    @IBOutlet weak var centerView: UIView!
    
    
    var btnsBlock : (() ->Void)?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        contentView.setshadowView()
        
    }
    
    @IBAction func handlebtnSender(_ sender: Any) {
        if btnsBlock != nil {
            btnsBlock!()
        }
    }
}
