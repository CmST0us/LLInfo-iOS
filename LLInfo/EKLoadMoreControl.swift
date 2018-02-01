//
//  EKLoadMoreControl.swift
//  LLInfo
//
//  Created by CmST0us on 2017/11/18.
//  Copyright © 2017年 eki. All rights reserved.
//

import UIKit

class EKLoadMoreControl: UIControl {

    
    override func didMoveToSuperview() {
        let v = self.superview as! UIScrollView
        v.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath! {
        case "contentOffset":
            
            break
        default:
            break
        }
    }

}
