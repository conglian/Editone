//
//  EoLibraryViewCell.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 17/03/2026.
//

import UIKit

class EoLibraryViewCell: UITableViewCell {
    
    @IBOutlet weak var lib_tilte_label: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        contentView.setshadowView()
        
    }
    
}
