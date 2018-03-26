//
//  MainTabBarController.swift
//  LLInfo
//
//  Created by CmST0us on 2018/3/27.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    var lastSelectIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.lastSelectIndex = self.selectedIndex
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if tabBarController.selectedIndex == 1 && tabBarController.selectedViewController == viewController {
            return false
        }
        lastSelectIndex = tabBarController.selectedIndex
        return true
    }
}
