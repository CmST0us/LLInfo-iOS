//
//  MBProgressHUD+Async.swift
//  LLInfo
//
//  Created by CmST0us on 2018/5/2.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import MBProgressHUD

extension MBProgressHUD {
    func setLabelTextAsync(text: String) {
        DispatchQueue.main.async {
            self.label.text = text
        }
    }
    
    func hideAsync(animated: Bool, afterDelay delayTime: TimeInterval = 0) {
        DispatchQueue.main.async {
            self.hide(animated: animated, afterDelay: delayTime)
        }
    }
    
    func customAsyncMethod(customBlock: @escaping ((_ hud: MBProgressHUD) -> Void)) {
        DispatchQueue.main.async {
            customBlock(self)
        }
    }
}
