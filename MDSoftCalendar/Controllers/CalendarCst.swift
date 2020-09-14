//
//  CalendarCst.swift
//  SimpleApp4
//
//  Created by maedi laziman on 05/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

protocol CalendarCst_Interface {
    func setCollWIthCurrentDate(dnow: String)
    func countDayInMonth(cnDayInMonth: Int)
    func getDayNameInMonthStart(dayName: String)
}

public protocol CalendarCst_Communicate {
    func getCalendarValue(value: [String])
}

extension CalendarCst: MonthCollection_Interface {
    func moveToCurrentMonth(idx: Int){
        moveToSpecificMonth(pgIndex: idx)
        toCurrentMonthPage(currentMonth: idx, changeLblMonthHeader: false)
    }
}

extension CalendarCst: DropDownYears_Interface{
    func getDataToDropDownYears(cell: UITableViewCell, indexPos: Int, makeDropDownIdentifier: String) {
        let customCell = cell as! TableDropDownYears
        let strLbl = arrUpYear[indexPos]
        customCell.labelTitle.text = strLbl
        customCell.labelTitle.tag = indexPos
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapCellDropDown))
        customCell.labelTitle.isUserInteractionEnabled = true
        customCell.labelTitle.addGestureRecognizer(tap)
    }
    
    func numberOfRowsYears(makeDropDownIdentifier: String) -> Int {
        return totalCellDropDownYears+1
    }
    
    func selectItemInDropDownYears(indexPos: Int, makeDropDownIdentifier: String) {
        dropDown.hideDropDown()
    }
    
}

extension CalendarCst: MDClndView_Interface{
    func tapItemCalendar(idx: Int, value: String) {
        strFnResultDate = value
        hideDropDownYears()
        if delegateCommunicate != nil {
            var valcal: [String] = []
            valcal.append(String(numFnResultYears))
            valcal.append(String(numFnResultMonth))
            valcal.append(strFnResultDate)
            delegateCommunicate?.getCalendarValue(value: valcal)
        }
        if closeCalendarWhenItemChoosed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                self.removeAnimate()
            }
        }
    }
}

struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        return message
    }
}

//let fmBundle = Bundle(identifier: "com.abc.md.MDSoftCalendar")

public class CalendarCst: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
        }
    }
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var monthCollection: MonthCollection!
    
    @IBOutlet weak var btnNextMonth: UIButton!
    @IBOutlet weak var btnPreviousMonth: UIButton!
    @IBOutlet weak var parentViewHeaderMonth: UIView!
    @IBOutlet weak var lblMonthHeader: UILabel!
    
    @IBOutlet weak var parentViewHeaderYears: UIView!
    @IBOutlet weak var lblYearsHeader: UILabel!
    
    @IBAction func actNavLeft(_ sender: Any) {
        methodHelper.backNavLeft(view: self.view, controll: self)
    }
    
    let dropDown = DropDownYears()
    var dropDownRowHeight: CGFloat = 30
    var isShowDropDown: Bool!
    var totalCellDropDownYears = 70
    
    var slides:[MDClndSlide] = [];
    
    var hgFrCal: CGFloat = 0
    
    var delegateIface: CalendarCst_Interface?
    public var delegateCommunicate: CalendarCst_Communicate?
    
    @IBOutlet weak var collMonthFlowLayout: UICollectionViewFlowLayout!
    
    var Width_Window: Int!
    var Height_Window: Int!
    var changeHeaderTitleMonth: Bool!
    var numFnResultYears: Int!
    var numFnResultMonth: Int!
    var strFnResultDate: String!
    var strFnResultNameOfDay: String!
    var currentYear: Int!
    var arrUpYear: [String]!
    
    var mdClndView: MDClndView!
    public var backgroundBody: UIColor!
    public var backgroundWithSemiTransparent: Bool = true
    public var closeCalendarWhenItemChoosed: Bool = true
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        Width_Window = methodHelper.getWidthWindow()
        Height_Window = methodHelper.getHeightWindow()
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        self.scrollView.contentSize.height = 1.0 // disable vertical scroll
        let frmMonthColl = monthCollection.frame
        let hgmonthColl = frmMonthColl.height
        let xmonthColl = frmMonthColl.origin.x
        let ymonthColl = frmMonthColl.origin.y
        monthCollection.frame = CGRect(x:xmonthColl, y:ymonthColl, width: CGFloat(Width_Window), height: hgmonthColl)
        monthCollection.delegateAct(layout: collMonthFlowLayout)
        let posYHeaderYear = parentViewHeaderYears.frame.origin.y
        let hgHeaderYear = parentViewHeaderYears.frame.height
        parentViewHeaderYears.frame = CGRect(x:0, y:posYHeaderYear, width: CGFloat(Width_Window), height: hgHeaderYear)
        
        let wdwindowTwo = Width_Window/2
        let wdLblYear = lblYearsHeader.frame.width
        let hgLblYear = lblYearsHeader.frame.height
        let posNwXLblYear = wdwindowTwo - (Int(wdLblYear)/2)
        lblYearsHeader.frame = CGRect(x:CGFloat(posNwXLblYear), y:5, width: wdLblYear, height: hgLblYear)
        
        let posYHeaderMonth = parentViewHeaderMonth.frame.origin.y
        let hgHeaderMonth = parentViewHeaderMonth.frame.height
        parentViewHeaderMonth.frame = CGRect(x:0, y:posYHeaderMonth, width: CGFloat(Width_Window), height: hgHeaderMonth)
        
        let bnextMonth = btnNextMonth.imageView
        bnextMonth!.transform = CGAffineTransform(rotationAngle: .pi)
        let wdLblMonth = lblMonthHeader.frame.width
        let hgLblMonth = lblMonthHeader.frame.height
        let posNwXLblMonth = wdwindowTwo - (Int(wdLblMonth)/2)
        lblMonthHeader.frame = CGRect(x:CGFloat(posNwXLblMonth), y:14, width: wdLblMonth, height: hgLblMonth)
        
        let wdBtnPrevMonth = btnPreviousMonth.frame.width
        let hgBtnPrevMonth = btnPreviousMonth.frame.height
        let posNwXBtnPrevMonth = Width_Window - Int(wdBtnPrevMonth)
        btnPreviousMonth.frame = CGRect(x:CGFloat(posNwXBtnPrevMonth), y:0, width: wdBtnPrevMonth, height: hgBtnPrevMonth)
        currentYear = Date().getCurrentYearNumber()
        lblYearsHeader.text = String(currentYear)
        arrUpYear = []
        for i in 0 ..< (totalCellDropDownYears+1) {
           let x = totalCellDropDownYears - i
            let theYear = currentYear - x
            arrUpYear.append("\(theYear)")
        }
        isShowDropDown = false
        let tapLblYears = UITapGestureRecognizer(target: self, action: #selector(handleTapLblYears))
        lblYearsHeader.isUserInteractionEnabled = true
        lblYearsHeader.addGestureRecognizer(tapLblYears)
        
        changeHeaderTitleMonth = false
        numFnResultYears = currentYear
        numFnResultMonth = 0
        strFnResultDate = ""
        strFnResultNameOfDay = ""
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.toCurrentMonthPage(currentMonth: Date().getCurrentMonthNumber()-1, changeLblMonthHeader: true)
            self.monthCollection.delegateMnCollectionIface(clndCst: self)
        }
        
        let tapBody = UITapGestureRecognizer(target: self, action: #selector(self.handleTapBody(_:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapBody)
        
        if backgroundBody != nil {
            if backgroundWithSemiTransparent {
                view.backgroundColor = backgroundBody.withAlphaComponent(0.75)
            }
            else{
                view.backgroundColor = backgroundBody.withAlphaComponent(1)
            }
            view.isOpaque = false
        }
        else {
            view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
            view.isOpaque = false
        }
        showAnimate()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUpDropDown()
    }
    
    public func showMDSoftCalendar(comm: UIViewController, background: UIColor, backgroundWithSemiTransparent: Bool, closeCalendarWhenItemChoosed: Bool) {
        let fmBundle = Bundle(for: type(of: self))
        let popvc = UIStoryboard(name: "Board_Calendar", bundle: fmBundle).instantiateViewController(withIdentifier: "CalendarCst_ID") as! CalendarCst
        popvc.modalPresentationStyle = .overCurrentContext
        popvc.modalTransitionStyle = .crossDissolve
        popvc.backgroundBody = background
        popvc.backgroundWithSemiTransparent = backgroundWithSemiTransparent
        popvc.closeCalendarWhenItemChoosed = closeCalendarWhenItemChoosed
        popvc.delegateCommunicate = comm as? CalendarCst_Communicate
        comm.addChild(popvc)
        popvc.view.frame = comm.view.frame
        comm.view.addSubview(popvc.view)
        popvc.didMove(toParent: comm)
    }
    
    @objc func handleTapBody(_ touch: UITapGestureRecognizer? = nil) {
        let view = touch?.view
        let loc = touch?.location(in: view)
        let subview = view?.hitTest(loc!, with: nil)
        hideDropDownYears()
        if !subview!.isOpaque {
            removeAnimate()
        }
    }
    
    func hideDropDownYears(){
        if isShowDropDown {
            isShowDropDown = false
            dropDown.hideDropDown()
        }
    }
    
    @IBAction func actPreviousMonth(_ sender: Any) {
        let idx = numFnResultMonth-1
        if idx >= 0 {
            excPrevNextMonth(index: idx)
        }
    }
    
    @IBAction func actNextMonth(_ sender: Any) {
        let idx = numFnResultMonth+1
        if idx < 12 {
            excPrevNextMonth(index: idx)
        }
    }
    
    func excPrevNextMonth(index: Int){
        moveToSpecificMonth(pgIndex: index)
        toCurrentMonthPage(currentMonth: index, changeLblMonthHeader: false)
    }
    
    func getMonthName(idx: Int) -> String {
        var monthName = ""
        switch idx {
            case 0:
                monthName = "January"
                break
            case 1:
                monthName = "February"
                break
            case 2:
                monthName = "March"
                break
            case 3:
                monthName = "April"
                break
            case 4:
                monthName = "May"
                break
            case 5:
                monthName = "June"
                break
            case 6:
                monthName = "July"
                break
            case 7:
                monthName = "August"
                break
            case 8:
                monthName = "September"
                break
            case 9:
                monthName = "October"
                break
            case 10:
                monthName = "November"
                break
            case 11:
                monthName = "December"
                break
            default:
                break
        }
        return monthName
    }
    
    func setListener_MonthCollection(mnCollection: MonthCollection){
        monthCollection = mnCollection
        monthCollection.delegateIface = self
        //if monthCollection.delegateIface == nil {}else{}
    }
    
    func setListener_MDClndView(clndView: MDClndView){
        mdClndView = clndView
        clndView.delegateIface = self
        //if clndView.delegateIface == nil {}else{}
    }
    
    func createSlides() -> [MDClndSlide] {
        let fmBundle = Bundle(for: type(of: self))
        let strCurDate = Date().shortDate
        let splitsCurDate = strCurDate.components(separatedBy: "/")
        let chCurDate = splitsCurDate[1]
        let nibSlide = "MDClndSlide"
        let strFnDate  = methodHelper.removeZeroInFront(v: chCurDate)
        let slide1:MDClndSlide = fmBundle.loadNibNamed(nibSlide, owner: self, options: nil)?.first as! MDClndSlide
        let fview = slide1.viewClnd
        let frView = fview!.frame
        hgFrCal = frView.height
        var nameOfDay = getNameOfDay(numOfMonth: 1)
        slide1.setListener(clndCst: self)
        setDelegateSlide(nmOfDay: nameOfDay, srFnDate: strFnDate)
        
        nameOfDay = getNameOfDay(numOfMonth: 2)
        let slide2:MDClndSlide = fmBundle.loadNibNamed(nibSlide, owner: self, options: nil)?.first as! MDClndSlide
        slide2.setListener(clndCst: self)
        setDelegateSlide(nmOfDay: nameOfDay, srFnDate: strFnDate)
        
        nameOfDay = getNameOfDay(numOfMonth: 3)
        let slide3:MDClndSlide = fmBundle.loadNibNamed(nibSlide, owner: self, options: nil)?.first as! MDClndSlide
        slide3.setListener(clndCst: self)
        setDelegateSlide(nmOfDay: nameOfDay, srFnDate: strFnDate)
        
        nameOfDay = getNameOfDay(numOfMonth: 4)
        let slide4:MDClndSlide = fmBundle.loadNibNamed(nibSlide, owner: self, options: nil)?.first as! MDClndSlide
        slide4.setListener(clndCst: self)
        setDelegateSlide(nmOfDay: nameOfDay, srFnDate: strFnDate)
        
        nameOfDay = getNameOfDay(numOfMonth: 5)
        let slide5:MDClndSlide = fmBundle.loadNibNamed(nibSlide, owner: self, options: nil)?.first as! MDClndSlide
        slide5.setListener(clndCst: self)
        setDelegateSlide(nmOfDay: nameOfDay, srFnDate: strFnDate)
        
        nameOfDay = getNameOfDay(numOfMonth: 6)
        let slide6:MDClndSlide = fmBundle.loadNibNamed(nibSlide, owner: self, options: nil)?.first as! MDClndSlide
        slide6.setListener(clndCst: self)
        setDelegateSlide(nmOfDay: nameOfDay, srFnDate: strFnDate)
        
        nameOfDay = getNameOfDay(numOfMonth: 7)
        let slide7:MDClndSlide = fmBundle.loadNibNamed(nibSlide, owner: self, options: nil)?.first as! MDClndSlide
        slide7.setListener(clndCst: self)
        setDelegateSlide(nmOfDay: nameOfDay, srFnDate: strFnDate)
        
        nameOfDay = getNameOfDay(numOfMonth: 8)
        let slide8:MDClndSlide = fmBundle.loadNibNamed(nibSlide, owner: self, options: nil)?.first as! MDClndSlide
        slide8.setListener(clndCst: self)
        setDelegateSlide(nmOfDay: nameOfDay, srFnDate: strFnDate)
        
        nameOfDay = getNameOfDay(numOfMonth: 9)
        let slide9:MDClndSlide = fmBundle.loadNibNamed(nibSlide, owner: self, options: nil)?.first as! MDClndSlide
        slide9.setListener(clndCst: self)
        setDelegateSlide(nmOfDay: nameOfDay, srFnDate: strFnDate)
        
        nameOfDay = getNameOfDay(numOfMonth: 10)
        let slide10:MDClndSlide = fmBundle.loadNibNamed(nibSlide, owner: self, options: nil)?.first as! MDClndSlide
        slide10.setListener(clndCst: self)
        setDelegateSlide(nmOfDay: nameOfDay, srFnDate: strFnDate)
        
        nameOfDay = getNameOfDay(numOfMonth: 11)
        let slide11:MDClndSlide = fmBundle.loadNibNamed(nibSlide, owner: self, options: nil)?.first as! MDClndSlide
        slide11.setListener(clndCst: self)
        setDelegateSlide(nmOfDay: nameOfDay, srFnDate: strFnDate)
        
        nameOfDay = getNameOfDay(numOfMonth: 12)
        let slide12:MDClndSlide = fmBundle.loadNibNamed(nibSlide, owner: self, options: nil)?.first as! MDClndSlide
        slide12.setListener(clndCst: self)
        setDelegateSlide(nmOfDay: nameOfDay, srFnDate: strFnDate)
            
        return [slide1, slide2, slide3, slide4, slide5, slide6, slide7, slide8, slide9, slide10, slide11, slide12]
    }
    
    func setDelegateSlide(nmOfDay: [String], srFnDate: String){
        //if delegateIface == nil {}
        delegateIface?.countDayInMonth(cnDayInMonth: Int(nmOfDay[1])!)
        delegateIface?.getDayNameInMonthStart(dayName: nmOfDay[0])
        delegateIface?.setCollWIthCurrentDate(dnow: srFnDate)
    }
    
    func getNameOfDay(numOfMonth: Int) -> [String]{
        let calendar: Calendar = Calendar.current
        let startDate = calendar.startOfMonth(Date(), numberOfMonth: numOfMonth)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: startDate)
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        let numDays = range.count
        
        return [dayInWeek, String(numDays)]
    }
    
    func toCurrentMonthPage(currentMonth: Int, changeLblMonthHeader: Bool){
        let pageWidth:CGFloat = self.scrollView.frame.width
        let slideToX = pageWidth * CGFloat(currentMonth)
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
        let nmOfMonth = getMonthName(idx: currentMonth)
        if changeLblMonthHeader {
            lblMonthHeader.text = nmOfMonth
        }
        numFnResultMonth = currentMonth
    }
    
    func setupSlideScrollView(slides : [MDClndSlide]) {
        let posYScr = scrollView.frame.origin.y
        scrollView.frame = CGRect(x: 0, y: posYScr, width: view.frame.width, height: hgFrCal)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        let nmOfMonth = getMonthName(idx: Int(pageIndex))
        lblMonthHeader.text = nmOfMonth
        numFnResultMonth = Int(pageIndex)
        hideDropDownYears()
        moveToSpecificMonth(pgIndex: Int(pageIndex))
    }
    
    func moveToSpecificMonth(pgIndex: Int){
        monthCollection.scrollToItem(at: IndexPath(row: Int(pgIndex), section: 0), at: .centeredHorizontally, animated: true)
        if !changeHeaderTitleMonth {
            changeHeaderTitleMonth = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.monthCollection.showCurrentMonth(idxPath: self.numFnResultMonth)
                self.changeHeaderTitleMonth = false
            }
        }
    }
        
    func scrollView(_ scrollView: UIScrollView, didScrollToPercentageOffset percentageHorizontalOffset: CGFloat) {
            if(pageControl.currentPage == 0) {
                let pageUnselectedColor: UIColor = fade(fromRed: 255/255, fromGreen: 255/255, fromBlue: 255/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
                pageControl.pageIndicatorTintColor = pageUnselectedColor
                let bgColor: UIColor = fade(fromRed: 103/255, fromGreen: 58/255, fromBlue: 183/255, fromAlpha: 1, toRed: 255/255, toGreen: 255/255, toBlue: 255/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
                slides[pageControl.currentPage].backgroundColor = bgColor
                let pageSelectedColor: UIColor = fade(fromRed: 81/255, fromGreen: 36/255, fromBlue: 152/255, fromAlpha: 1, toRed: 103/255, toGreen: 58/255, toBlue: 183/255, toAlpha: 1, withPercentage: percentageHorizontalOffset * 3)
                pageControl.currentPageIndicatorTintColor = pageSelectedColor
            }
    }
    
    func setUpDropDown(){
        let fmBundle = Bundle(for: type(of: self))
        dropDown.makeDropDownIdentifier = "DROP_DOWN_NEW"
        dropDown.cellReusableIdentifier = "dropDownCell"
        dropDown.makeDropDownDataSourceProtocol = self
        dropDown.setUpDropDown(viewPositionReference: (lblYearsHeader.frame), offset: 2)
        dropDown.nib = UINib(nibName: "TableDropDownYears", bundle: fmBundle)
        dropDown.setRowHeight(height: self.dropDownRowHeight)
        self.view.addSubview(dropDown)
        
    }
    
    @objc func handleTapLblYears(sender: UITapGestureRecognizer){
        let h = hgFrCal+50
        isShowDropDown = dropDown.showDropDown(heightdd: h)
        let frmLblYears = self.lblYearsHeader.frame
        let posYActualDropDown = frmLblYears.height + 85
        let wdDropDownYears = frmLblYears.width
        let posXDropDownYears = frmLblYears.origin.x
        dropDown.frame = CGRect(x: posXDropDownYears, y: posYActualDropDown, width: CGFloat(wdDropDownYears), height: h)
    }
    
    @objc func handleTapCellDropDown(sender: UITapGestureRecognizer) {
          let sentLabel = sender.view as? UILabel
          if let lbl = sentLabel {
            let tag = lbl.tag
            isShowDropDown = false
            dropDown.hideDropDown()
            let dt = arrUpYear[tag]
            lblYearsHeader.text = dt
            numFnResultYears = Int(dt)
        }
    }
        
    func fade(fromRed: CGFloat,
                  fromGreen: CGFloat,
                  fromBlue: CGFloat,
                  fromAlpha: CGFloat,
                  toRed: CGFloat,
                  toGreen: CGFloat,
                  toBlue: CGFloat,
                  toAlpha: CGFloat,
                  withPercentage percentage: CGFloat) -> UIColor {
            
            let red: CGFloat = (toRed - fromRed) * percentage + fromRed
            let green: CGFloat = (toGreen - fromGreen) * percentage + fromGreen
            let blue: CGFloat = (toBlue - fromBlue) * percentage + fromBlue
            let alpha: CGFloat = (toAlpha - fromAlpha) * percentage + fromAlpha
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
