//
//  MDClndSlide.swift
//  SimpleApp4
//
//  Created by maedi laziman on 05/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

protocol MDClndSlide_Interface {
    func reloadCollWIthCurrentDate(dateNow: String)
    func loadCountDayInMonth(numberDayInMonth: Int)
    func loadDayNameInMonthStart(stDayName: String)
}

extension MDClndSlide: CalendarCst_Interface {
    func setCollWIthCurrentDate(dnow: String) {
        delegateIface?.reloadCollWIthCurrentDate(dateNow: dnow)
    }
    
    func countDayInMonth(cnDayInMonth: Int) {
        delegateIface?.loadCountDayInMonth(numberDayInMonth: cnDayInMonth)
    }
    
    func getDayNameInMonthStart(dayName: String) {
        delegateIface?.loadDayNameInMonthStart(stDayName: dayName)
    }
}

class MDClndSlide: UIView {
    
    @IBOutlet weak var viewClnd: MDClndView!
    
    var calCst: CalendarCst!
    var delegateIface: MDClndSlide_Interface?
    var heightCalendarView = 360
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        print("MDClndSlide start draw")
        setViewWidthAndHeight()
        setNeedsDisplay()
    }
    */
    
    func setListener(clndCst: CalendarCst){
        calCst = clndCst
        calCst.delegateIface = self
        //if calCst.delegateIface == nil {}else{}
        viewClnd.setListener(clndSlide: self)
        viewClnd.delegateMClndViewIface(clndCst: calCst)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews();
        setViewWidthAndHeight()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setViewWidthAndHeight(){
        let widthWindow = methodHelper.getWidthWindow()
        let posx = 5
        let wdView = widthWindow - (posx*4)
        viewClnd.frame = CGRect(x:posx, y:0, width:wdView, height: heightCalendarView)
    }

}
