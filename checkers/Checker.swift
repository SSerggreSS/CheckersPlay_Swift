//
//  Checker.swift
//  checkers
//
//  Created by Сергей on 03/10/2019.
//  Copyright © 2019 Sergei. All rights reserved.
//

import UIKit
@IBDesignable

class Checker: UIView {
   
    override func draw(_ rect: CGRect) {
        super.layer.masksToBounds = true
        super.layer.cornerRadius = 32.0
    }


}
