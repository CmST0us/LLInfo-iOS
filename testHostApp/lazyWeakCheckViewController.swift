//
//  lazyWeakCheckViewController.swift
//  testHostApp
//
//  Created by CmST0us on 2018/4/24.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class lazyWeakCheckViewController: UIViewController {

    lazy var data: [Int] = {
        var dd: [Int] = []
        for i in 0 ... self.count {
            dd.append(i)
        }
        return dd
    }()
    
    var count = 10
    
    var workItem: DispatchWorkItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        Logger.shared.console(data.description)
        
        workItem = DispatchWorkItem(block: { [weak self] in
            Logger.shared.console("workItem start")
            Thread.sleep(forTimeInterval: 2)
            Logger.shared.console("workItem sleep")
            
            if let weakSelf = self{
                weakSelf.count += 1
            }
            
            Thread.sleep(forTimeInterval: 2)
            Logger.shared.console("workItem sleep")
        })
        
        DispatchQueue.global().async(execute: workItem)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        workItem.cancel()
    }
    deinit {
        Logger.shared.console("deinit")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
