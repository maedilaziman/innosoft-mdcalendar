//
//  DropDownYears.swift
//  SimpleApp4
//
//  Created by maedi laziman on 11/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

protocol DropDownYears_Interface{
    func getDataToDropDownYears(cell: UITableViewCell, indexPos: Int, makeDropDownIdentifier: String)
    func numberOfRowsYears(makeDropDownIdentifier: String) -> Int
    func selectItemInDropDownYears(indexPos: Int, makeDropDownIdentifier: String)
}

class DropDownYears: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var makeDropDownIdentifier: String = "DROP_DOWN"
    var cellReusableIdentifier: String = "DROP_DOWN_CELL"
    var dropDownTableView: UITableView?
    var width: CGFloat = 0
    var offset:CGFloat = 0
    var makeDropDownDataSourceProtocol: DropDownYears_Interface?
    var nib: UINib?{
         didSet{
             dropDownTableView?.register(nib, forCellReuseIdentifier: self.cellReusableIdentifier)
         }
    }
    var viewPositionRef: CGRect?
    var isDropDownPresent: Bool = false
     
    func setUpDropDown(viewPositionReference: CGRect,  offset: CGFloat){
         self.addBorders()
         self.addShadowToView()
         self.frame = CGRect(x: viewPositionReference.minX, y: viewPositionReference.maxY + offset, width: 0, height: 0)
         dropDownTableView = UITableView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: 0, height: 0))
         self.width = viewPositionReference.width
         self.offset = offset
         self.viewPositionRef = viewPositionReference
         dropDownTableView?.showsVerticalScrollIndicator = false
         dropDownTableView?.showsHorizontalScrollIndicator = false
         dropDownTableView?.backgroundColor = .white
        dropDownTableView?.separatorStyle = .none
         dropDownTableView?.delegate = self
         dropDownTableView?.dataSource = self
         dropDownTableView?.allowsSelection = true
         dropDownTableView?.isUserInteractionEnabled = true
         dropDownTableView?.tableFooterView = UIView()
         self.addSubview(dropDownTableView!)
         
    }
     
    func showDropDown(heightdd: CGFloat) -> Bool{
        isDropDownPresent = true
        self.frame = CGRect(x: (self.viewPositionRef?.minX)!, y: 0, width: width, height: 0)
        self.dropDownTableView?.frame = CGRect(x: 0, y: 0, width: width, height: 0)
        self.dropDownTableView?.reloadData()
         
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.05, options: .curveLinear
             , animations: {
             self.frame.size = CGSize(width: self.width, height: heightdd)
             self.dropDownTableView?.frame.size = CGSize(width: self.width, height: heightdd)
         })
         return isDropDownPresent
     }
     
     func reloadDropDown(height: CGFloat){
         self.frame = CGRect(x: (self.viewPositionRef?.minX)!, y: (self.viewPositionRef?.maxY)!
             + self.offset, width: width, height: 0)
         self.dropDownTableView?.frame = CGRect(x: 0, y: 0, width: width, height: 0)
         self.dropDownTableView?.reloadData()
         UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.05, options: .curveLinear
             , animations: {
             self.frame.size = CGSize(width: self.width, height: height)
             self.dropDownTableView?.frame.size = CGSize(width: self.width, height: height)
         })
     }
     
     func setRowHeight(height: CGFloat){
         self.dropDownTableView?.rowHeight = height
         self.dropDownTableView?.estimatedRowHeight = height
     }
     
     func hideDropDown(){
         isDropDownPresent = false
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveLinear
             , animations: {
             self.frame.size = CGSize(width: self.width, height: 0)
             self.dropDownTableView?.frame.size = CGSize(width: self.width, height: 0)
         })
     }
     
     func removeDropDown(){
         UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: .curveLinear
             , animations: {
             self.dropDownTableView?.frame.size = CGSize(width: 0, height: 0)
         }) { (_) in
             self.removeFromSuperview()
             self.dropDownTableView?.removeFromSuperview()
         }
     }

    
}


extension DropDownYears: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (makeDropDownDataSourceProtocol?.numberOfRowsYears(makeDropDownIdentifier: self.makeDropDownIdentifier) ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (dropDownTableView?.dequeueReusableCell(withIdentifier: self.cellReusableIdentifier) ?? UITableViewCell())
        makeDropDownDataSourceProtocol?.getDataToDropDownYears(cell: cell, indexPos: indexPath.row, makeDropDownIdentifier: self.makeDropDownIdentifier)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        makeDropDownDataSourceProtocol?.selectItemInDropDownYears(indexPos: indexPath.row, makeDropDownIdentifier: self.makeDropDownIdentifier)
    }
}

extension UIView{
    func addBordersDropDownYears(borderWidth: CGFloat = 0.2, borderColor: CGColor = UIColor.lightGray.cgColor){
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
        
    func addShadowDropDownYears(shadowRadius: CGFloat = 2, alphaComponent: CGFloat = 0.6) {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: alphaComponent).cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 2)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = 1
    }
}

