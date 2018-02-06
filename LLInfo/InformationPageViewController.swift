//
//  InformationPageViewController.swift
//  LLInfo
//
//  Created by CmST0us on 2018/2/4.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import Tabman
import Pageboy

class InformationPageViewController: TabmanViewController{
    
    lazy var viewControllers: [UIViewController] = {
       return [
            InfoListTableViewController.storyboardInstance(),
            OfficialNewsListTableViewController.storyboardInstance()
        ]
    }()
    
    
}

// MARK: - View life cycle method
extension InformationPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        self.bounces = false
        self.bar.items = [
            Item(title: "情报"),
            Item(title: "公式消息")
        ]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension InformationPageViewController: PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return self.viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        return self.viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
