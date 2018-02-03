//
//  UIPageViewController+ScrollView.swift
//  LLInfo
//
//  Created by CmST0us on 2018/2/4.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation
extension UIPageViewController {
    var scrollView: UIScrollView {
        for v in self.view.subviews {
            if v.isKind(of: UIScrollView.self) {
                return v as! UIScrollView
            }
        }
        return UIScrollView()
    }
}
