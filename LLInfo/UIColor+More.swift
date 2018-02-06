//
//  UIColor+More.swift
//  LLInfo
//
//  Created by CmST0us on 2018/2/5.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(r: Int, g: Int, b: Int) {
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }
    
    class var aqua: UIColor {
        return UIColor(r: 0, g: 150, b: 255)
    }
}
