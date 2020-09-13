//
//  MonthCollection.swift
//  SimpleApp4
//
//  Created by maedi laziman on 08/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

struct MonthTitleModel {
    var title: String?
    var currentMonth: Bool?
}

protocol MonthCollection_Interface {
    func moveToCurrentMonth(idx: Int)
}

class MonthCollection: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var delegateIface: MonthCollection_Interface?
    var countMonth = 12
    var arrMonth: [MonthTitleModel] = [MonthTitleModel(title: "January", currentMonth: false), MonthTitleModel(title: "February", currentMonth: false),
                                MonthTitleModel(title: "March", currentMonth: false), MonthTitleModel(title: "April", currentMonth: false),
                                MonthTitleModel(title: "May", currentMonth: false), MonthTitleModel(title: "June", currentMonth: false),
                                MonthTitleModel(title: "July", currentMonth: false), MonthTitleModel(title: "August", currentMonth: false),
                                MonthTitleModel(title: "September", currentMonth: false), MonthTitleModel(title: "October", currentMonth: false),
                                MonthTitleModel(title: "November", currentMonth: false), MonthTitleModel(title: "December", currentMonth: false)]
    
    override func layoutSubviews() {
        super.layoutSubviews();
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "month_cell", for: indexPath) as! MonthCollectionCell
        cell.configCell(model: arrMonth[indexPath.row])
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        
        return cell
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
       let location = sender.location(in: self)
       let indexPath = self.indexPathForItem(at: location)
       if let index = indexPath {
        if delegateIface == nil {}
        else{
            delegateIface?.moveToCurrentMonth(idx: index.row)
        }
       }
    }
    
    func delegateMnCollectionIface(clndCst: CalendarCst){
        clndCst.setListener_MonthCollection(mnCollection: self)
    }
    
    func delegateAct(layout: UICollectionViewFlowLayout){
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 91, height: 32)
        delegate = self
        dataSource = self
    }
    
    func showCurrentMonth(idxPath: Int){
        let cloneArrMonth = arrMonth
        arrMonth.removeAll()
        for i in (0..<cloneArrMonth.count) {
            if i == idxPath {
                self.arrMonth.append(MonthTitleModel(title: cloneArrMonth[i].title, currentMonth: true))
            }
            else {
                self.arrMonth.append(MonthTitleModel(title: cloneArrMonth[i].title, currentMonth: false))
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
          guard let self = self else {return}
            self.reloadData()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
