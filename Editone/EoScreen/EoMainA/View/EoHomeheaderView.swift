//
//  EoHomeheaderView.swift
//  Editone
//
//  Created by ECHELON MATRIX ENTERPRISES on 17/03/2026.
//

import UIKit

class EoHomeheaderView: UIView {
    
    var presentBlocks : (() -> Void)?
    
    var presentUploadBlocks : (() -> Void)?
    
    var nextBlocks : (() -> Void)?

    @IBOutlet weak var imageView1: UIButton!
    
    @IBOutlet weak var imageView2: UIButton!
    
    @IBOutlet weak var imageView3: UIButton!
    
    @IBOutlet weak var imageView4: UIButton!
    
    func loadViewFromNib() -> EoHomeheaderView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EoHomeheaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! EoHomeheaderView
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView1.imageView?.contentMode = .scaleAspectFill
        imageView2.imageView?.contentMode = .scaleAspectFill
        imageView3.imageView?.contentMode = .scaleAspectFill
        imageView4.imageView?.contentMode = .scaleAspectFill
        updateSletecd(row: 0)
    }

    @IBAction func handleUploadSender(_ sender: Any) {
        Eo_Log("handleUploadSender")
        if presentUploadBlocks != nil {
            presentUploadBlocks!();
        }
    }
    
    @IBAction func handleRecordSender(_ sender: Any) {
        if presentBlocks != nil {
            presentBlocks!();
        }
    }
    
    @IBAction func handleMusicTypeOneSender(_ sender: Any) {
        Eo_Log("handleMusicTypeOneSender")
        updateSletecd(row: 0)
    }
    
    @IBAction func handleMusicTypeTwoSender(_ sender: Any) {
        Eo_Log("handleMusicTypeTwoSender")
        updateSletecd(row: 1)
    }
    
    @IBAction func handleMusicTypeThreeSender(_ sender: Any) {
        Eo_Log("handleMusicTypeThreeSender")
        updateSletecd(row: 2)
    }
    
    @IBAction func handleMusicTypeFourSender(_ sender: Any) {
        Eo_Log("handleMusicTypeFourSender")
        updateSletecd(row: 3)
    }
    
    @IBAction func handleMusicTypeNextSender(_ sender: Any) {
        Eo_Log("handleMusicTypeNextSender")
        if nextBlocks != nil {
            nextBlocks!();
        }
    }
    
    
    func updateSletecd(row : Int){
        if row == 0 {
            
            // 设置圆角
            imageView1.layer.cornerRadius = 16
            imageView1.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView1.layer.borderWidth = 1
            imageView1.layer.borderColor = UIColor.init(hexString: "#7395FF").cgColor
            
            // 设置圆角
            imageView2.layer.cornerRadius = 16
            imageView2.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView2.layer.borderWidth = 1
            imageView2.layer.borderColor = UIColor.clear.cgColor
            
            // 设置圆角
            imageView3.layer.cornerRadius = 16
            imageView3.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView3.layer.borderWidth = 1
            imageView3.layer.borderColor = UIColor.clear.cgColor
            
            // 设置圆角
            imageView4.layer.cornerRadius = 16
            imageView4.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView4.layer.borderWidth = 1
            imageView4.layer.borderColor = UIColor.clear.cgColor
            
        } else if row == 1 {
            
            // 设置圆角
            imageView1.layer.cornerRadius = 16
            imageView1.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView1.layer.borderWidth = 1
            imageView1.layer.borderColor = UIColor.clear.cgColor

            // 设置圆角
            imageView2.layer.cornerRadius = 16
            imageView2.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView2.layer.borderWidth = 1
            imageView2.layer.borderColor = UIColor.init(hexString: "#7395FF").cgColor

            // 设置圆角
            imageView3.layer.cornerRadius = 16
            imageView3.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView3.layer.borderWidth = 1
            imageView3.layer.borderColor = UIColor.clear.cgColor
            
            // 设置圆角
            imageView4.layer.cornerRadius = 16
            imageView4.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView4.layer.borderWidth = 1
            imageView4.layer.borderColor = UIColor.clear.cgColor
            
        } else if row == 2 {
            
            // 设置圆角
            imageView1.layer.cornerRadius = 16
            imageView1.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView1.layer.borderWidth = 1
            imageView1.layer.borderColor = UIColor.clear.cgColor

            // 设置圆角
            imageView2.layer.cornerRadius = 16
            imageView2.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView2.layer.borderWidth = 1
            imageView2.layer.borderColor = UIColor.clear.cgColor

            // 设置圆角
            imageView3.layer.cornerRadius = 16
            imageView3.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView3.layer.borderWidth = 1
            imageView3.layer.borderColor = UIColor.init(hexString: "#7395FF").cgColor

            // 设置圆角
            imageView4.layer.cornerRadius = 16
            imageView4.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView4.layer.borderWidth = 1
            imageView4.layer.borderColor = UIColor.clear.cgColor
            
        } else {
            
            // 设置圆角
            imageView1.layer.cornerRadius = 16
            imageView1.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView1.layer.borderWidth = 1
            imageView1.layer.borderColor = UIColor.clear.cgColor

            // 设置圆角
            imageView2.layer.cornerRadius = 16
            imageView2.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView2.layer.borderWidth = 1
            imageView2.layer.borderColor = UIColor.clear.cgColor

            // 设置圆角
            imageView3.layer.cornerRadius = 16
            imageView3.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView3.layer.borderWidth = 1
            imageView3.layer.borderColor = UIColor.clear.cgColor

            // 设置圆角
            imageView4.layer.cornerRadius = 16
            imageView4.layer.masksToBounds = true // ⚠️ 必须，否则圆角无效

            // 设置边线
            imageView4.layer.borderWidth = 1
            imageView4.layer.borderColor = UIColor.init(hexString: "#7395FF").cgColor

        }
    }
    
    
}
