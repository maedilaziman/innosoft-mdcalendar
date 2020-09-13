//
//  ViewHelper.swift
//  SimpleApp4
//
//  Created by maedi laziman on 05/07/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

class ViewHelper: UIViewController {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension String {
    var isNumeric : Bool {
        return Double(self) != nil
    }
}

extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
}
extension Formatter {
    static let date = DateFormatter()
}
extension Date {
    func localizedDescription(dateStyle: DateFormatter.Style = .medium,
                              timeStyle: DateFormatter.Style = .medium,
                              in timeZone : TimeZone = .current,
                              locale   : Locale = .current,
                              strFormat: String = "MM/dd/yyyy") -> String {
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateStyle = dateStyle
        Formatter.date.timeStyle = timeStyle
        Formatter.date.dateFormat = strFormat
        return Formatter.date.string(from: self)
    }
    var localizedDescription: String { localizedDescription() }
    /*
     how this used ?
     Date().localizedDescription                                                // "Sep 26, 2018 at 12:03:41 PM"
     Date().localizedDescription(in: .gmt)                                      // "Sep 26, 2018 at 3:03:41 PM" UTC TIME
     Date().localizedDescription(dateStyle: .short, timeStyle: .short)          //  "9/26/18, 12:03 PM"
     Date().localizedDescription(dateStyle: .full, timeStyle: .full)            //  "Wednesday, September 26, 2018 at 12:03:41 PM Brasilia Standard Time"
     Date().localizedDescription(dateStyle: .full, timeStyle: .full, in: .gmt)  // "Wednesday, September 26, 2018 at 3:03:41 PM Greenwich Mean Time"
     */
    
    var fullDate: String   { localizedDescription(dateStyle: .full,   timeStyle: .none) }
    var longDate: String   { localizedDescription(dateStyle: .long,   timeStyle: .none) }
    var mediumDate: String { localizedDescription(dateStyle: .medium, timeStyle: .none) }
    var shortDate: String  { localizedDescription(dateStyle: .short,  timeStyle: .none) }

    var fullTime: String   { localizedDescription(dateStyle: .none,   timeStyle: .full) }
    var longTime: String   { localizedDescription(dateStyle: .none,   timeStyle: .long) }
    var mediumTime: String { localizedDescription(dateStyle: .none,   timeStyle: .medium) }
    var shortTime: String  { localizedDescription(dateStyle: .none,   timeStyle: .short) }

    var fullDateTime: String   { localizedDescription(dateStyle: .full,   timeStyle: .full) }
    var longDateTime: String   { localizedDescription(dateStyle: .long,   timeStyle: .long) }
    var mediumDateTime: String { localizedDescription(dateStyle: .medium, timeStyle: .medium) }
    var shortDateTime: String  { localizedDescription(dateStyle: .short,  timeStyle: .short) }
    
    /*
     how this used ?
     print(Date().fullDate)  // "Friday, May 26, 2017\n"
     print(Date().shortDate)  // "5/26/17\n"

     print(Date().fullTime)  // "10:16:24 AM Brasilia Standard Time\n"
     print(Date().shortTime)  // "10:16 AM\n"

     print(Date().fullDateTime)  // "Friday, May 26, 2017 at 10:16:24 AM Brasilia Standard Time\n"
     print(Date().shortDateTime)  // "5/26/17, 10:16 AM\n"
     */
    
    func getCurrentMonthNameAsString() -> String {
            let df = DateFormatter()
            df.setLocalizedDateFormatFromTemplate("MMM")
            return df.string(from: self)
    }
    /*
     how to used ?
     let date = Date()
     date.monthAsString() // Returns current month e.g. "May"
     */
    func getCurrentMonthNumber() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        let month = components.month!
        return month
    }
    
    func getCurrentYearNumber() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let year = components.year!
        return year
    }
}

extension Calendar {

    func dayOfWeek(_ date: Date) -> Int {
        var dayOfWeek = self.component(.weekday, from: date) + 1 - self.firstWeekday

        if dayOfWeek <= 0 {
            dayOfWeek += 7
        }

        return dayOfWeek
    }

    func startOfWeek(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(day: -self.dayOfWeek(date) + 1), to: date)!
    }

    func endOfWeek(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(day: 6), to: self.startOfWeek(date))!
    }

    func endOfMonth(_ date: Date, numberOfMonth: Int) -> Date {
        return self.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth(date, numberOfMonth: numberOfMonth))!
    }

    func startOfQuarter(_ date: Date) -> Date {
        let quarter = (self.component(.month, from: date) - 1) / 3 + 1
        return self.date(from: DateComponents(year: self.component(.year, from: date), month: (quarter - 1) * 3 + 1))!
    }

    func endOfQuarter(_ date: Date) -> Date {
        return self.date(byAdding: DateComponents(month: 3, day: -1), to: self.startOfQuarter(date))!
    }

    func startOfYear(_ date: Date) -> Date {
        return self.date(from: self.dateComponents([.year], from: date))!
    }

    func endOfYear(_ date: Date) -> Date {
        return self.date(from: DateComponents(year: self.component(.year, from: date), month: 12, day: 31))!
    }
    
    func startOfMonth(_ date: Date, numberOfMonth: Int) -> Date {
        return self.date(from: DateComponents(year: self.component(.year, from: date), month: numberOfMonth))!
    }
    /*
    func getCurrentMonthNumber() -> Int {
        let date = Date()
        let calendar = Calendar.current
        let components = DateComponents(year: self.component(.year, from: date), month: 9)//calendar.dateComponents([.month], from: date)
        let month = components.month!
        return month
    }
    */
}

extension UIView{
    func addBorders(borderWidth: CGFloat = 0.2, borderColor: CGColor = UIColor.lightGray.cgColor){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
    
    func addShadowToView(shadowRadius: CGFloat = 2, alphaComponent: CGFloat = 0.6) {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: alphaComponent).cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 2)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1
    }
}
