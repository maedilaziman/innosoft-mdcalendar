//
//  MDClndModel.swift
//  SimpleApp4
//
//  Created by maedi laziman on 05/09/20.
//  Copyright © 2020 maedi laziman. All rights reserved.
//

import UIKit

enum Calendar_TextColor : Int{
    case defColor
    case red
    case blue
}

struct MDClndModel {
    let mdate: String!
    let curDate: Bool!
    let txtColor: Calendar_TextColor!
}
