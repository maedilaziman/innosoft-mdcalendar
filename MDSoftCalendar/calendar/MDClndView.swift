//
//  MDClndView.swift
//  SimpleApp4
//
//  Created by maedi laziman on 05/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

protocol MDClndView_Interface {
    func tapItemCalendar(idx: Int, value: String)
}

extension MDClndView: MDClndSlide_Interface {
    func reloadCollWIthCurrentDate(dateNow: String) {
        reloadDataWithCurrentDate(currentDate: dateNow)
    }
    
    func loadCountDayInMonth(numberDayInMonth: Int){
        totalDayInMonth = numberDayInMonth
    }
    
    func loadDayNameInMonthStart(stDayName: String){
        idxOfDayName = getDayIndex(dayName: stDayName)
    }
}

class MDClndView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var calSlide: MDClndSlide!
    
    var collViewClnd: UICollectionView!
    
    var dataClnd: [MDClndModel] = [MDClndModel(mdate: "Sun", curDate: false, txtColor: Calendar_TextColor.red),
    MDClndModel(mdate: "Mon", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "Tue", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "Wed", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "Thr", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "Fri", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "Sat", curDate: false, txtColor: Calendar_TextColor.red),
    MDClndModel(mdate: "1", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "2", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "3", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "4", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "5", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "6", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "7", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "8", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "9", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "10", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "11", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "12", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "13", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "14", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "15", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "16", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "17", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "18", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "19", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "20", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "21", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "22", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "23", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "24", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "25", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "26", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "27", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "28", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "29", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "30", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "31", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "32", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "33", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "34", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "35", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "36", curDate: false, txtColor: Calendar_TextColor.defColor), MDClndModel(mdate: "37", curDate: false, txtColor: Calendar_TextColor.defColor),
    MDClndModel(mdate: "38", curDate: false, txtColor: Calendar_TextColor.defColor)]
    
    var totalDayTitle = 7
    var totalDayInMonth = 0
    var idxOfDayName = 1
    var delegateIface: MDClndView_Interface?
    
    func setListener(clndSlide: MDClndSlide){
        calSlide = clndSlide
        calSlide.delegateIface = self
        //if calSlide.delegateIface == nil {}else{}
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        createView()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func createView(){
        backgroundColor = UIColor(white: 1, alpha: 0.0)
        layer.shadowRadius = 4.0
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 40, height: 40)
        collViewClnd = UICollectionView(frame: self.frame, collectionViewLayout: layout)
        collViewClnd.backgroundColor = UIColor.white
        self.addSubview(collViewClnd)
        collViewClnd.dataSource = self
        collViewClnd.delegate = self
        collViewClnd.register(UINib.init(nibName: "MDCalendar", bundle: fmBundle), forCellWithReuseIdentifier: "calendar_cell")
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer) {
       let location = sender.location(in: collViewClnd)
       let indexPath = collViewClnd.indexPathForItem(at: location)
       if let index = indexPath {
        if delegateIface == nil {}
        else{
            let dx = index.row
            let val = dataClnd[dx].mdate
            let isNumber = val?.isNumeric
            if isNumber! {
                delegateIface?.tapItemCalendar(idx: dx, value: val!)
                reloadDataWithCurrentDate(currentDate: val!)
            }
        }
       }
    }
    
    func delegateMClndViewIface(clndCst: CalendarCst){
        clndCst.setListener_MDClndView(clndView: self)
    }
    
    func reloadDataWithCurrentDate(currentDate: String){
        var nwDataCln: [MDClndModel]!
        nwDataCln = []
        let idxStartDay = totalDayTitle + idxOfDayName
        var istartDay = 1
        for i in (0..<dataClnd.count) {
            if i <= 6 {
                if i == 0 || i == 6{
                    nwDataCln.append(MDClndModel(mdate: dataClnd[i].mdate, curDate: false, txtColor: Calendar_TextColor.red))
                }
                else {
                    nwDataCln.append(MDClndModel(mdate: dataClnd[i].mdate, curDate: false, txtColor: Calendar_TextColor.defColor))
                }
            } else {
                if i >= idxStartDay {
                    if istartDay <= totalDayInMonth {
                        nwDataCln.append(MDClndModel(mdate: String(istartDay), curDate: false, txtColor: Calendar_TextColor.defColor))
                        istartDay += 1
                    }
                    else {
                        nwDataCln.append(MDClndModel(mdate: "", curDate: false, txtColor: Calendar_TextColor.defColor))
                    }
                }
                else {
                    nwDataCln.append(MDClndModel(mdate: "", curDate: false, txtColor: Calendar_TextColor.defColor))
                }
            }
        }
        dataClnd.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
          guard let self = self else {return}
            for i in (0..<nwDataCln.count) {
                if nwDataCln[i].mdate == currentDate {
                    self.dataClnd.append(MDClndModel(mdate: nwDataCln[i].mdate, curDate: true, txtColor: Calendar_TextColor.defColor))
                }
                else {
                    self.dataClnd.append(MDClndModel(mdate: nwDataCln[i].mdate, curDate: false, txtColor: nwDataCln[i].txtColor))
                }
            }
            self.collViewClnd.reloadData()
        }
    }
    
    func getDayIndex(dayName: String) -> Int {
        var dayIndex = 1
        switch dayName {
            case "Sunday":
                dayIndex = 0
                break
            case "Monday":
                dayIndex = 1
                break
            case "Tuesday":
                dayIndex = 2
                break
            case "Wednesday":
                dayIndex = 3
                break
            case "Thursday":
                dayIndex = 4
                break
            case "Friday":
                dayIndex = 5
                break
            case "Saturday":
                dayIndex = 6
                break
            default:
                break
        }
        return dayIndex
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataClnd.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendar_cell", for: indexPath) as! MDCalendar
        cell.configure(model: dataClnd[indexPath.row])
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
    }

}
