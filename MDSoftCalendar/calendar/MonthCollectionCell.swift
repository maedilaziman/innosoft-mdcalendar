//
//  MonthCollectionCell.swift
//  SimpleApp4
//
//  Created by maedi laziman on 08/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

class MonthCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var monthName: UILabel!
    
    public func configCell(model: MonthTitleModel){
        monthName.text = model.title
        monthName.textColor = UIColor.black
        monthName.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        if model.currentMonth! {
            monthName.textColor = UIColor.systemBlue
            monthName.font = UIFont.systemFont(ofSize: 17.0, weight: .bold)
        }
    }
    
}
