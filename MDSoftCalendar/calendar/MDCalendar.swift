//
//  MDCalendar.swift
//  SimpleApp4
//
//  Created by maedi laziman on 05/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

class MDCalendar: UICollectionViewCell {
    
    @IBOutlet weak var parentWall: UIView!
    @IBOutlet weak var lblDate: UILabel!
    var txtColor: Calendar_TextColor!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func configure(model: MDClndModel){
        lblDate.text = model.mdate
        let txtColor = model.txtColor
        switch txtColor {
            case .defColor :
                lblDate.textColor = UIColor.black
                break
            case .red :
                lblDate.textColor = UIColor.red
                break
            case .blue :
                lblDate.textColor = UIColor.blue
                break
            default:
                lblDate.textColor = UIColor.black
                break
            }
        if model.curDate {
            parentWall.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            parentWall.alpha = 0.0
            UIView.animate(withDuration: 0.4, animations: {
                self.lblDate.textColor = UIColor.white
                self.parentWall.backgroundColor = methodHelper.hexStringToUIColor (hex:"#2766d2")
                self.parentWall.layer.cornerRadius = 4
                self.parentWall.alpha = 1.0
                self.parentWall.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            })
        }
        else {
            parentWall.backgroundColor = UIColor.white
            parentWall.layer.cornerRadius = 0
        }
    }
}
