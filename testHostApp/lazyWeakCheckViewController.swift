//
//  lazyWeakCheckViewController.swift
//  testHostApp
//
//  Created by CmST0us on 2018/4/24.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import MBProgressHUD

class lazyWeakCheckViewController: UIViewController {
    
    
    private lazy var progressHud: MBProgressHUD = {
        var hud = MBProgressHUD(view: self.view)
        return hud
    }()
    
    var workItem: DispatchWorkItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        func hideProgress(afterDelay: TimeInterval) {
            DispatchQueue.main.async { [weak self] in
                self?.progressHud.hide(animated: true, afterDelay: afterDelay)
            }
        }
        
        func setLabelText(text: String) {
            DispatchQueue.main.async { [weak self] in
                self?.progressHud.label.text = text
            }
        }
        
        self.view.addSubview(progressHud)
        progressHud.show(animated: true)
        progressHud.label.text = "loding..."
        
        workItem = DispatchWorkItem.init(block: { [weak self] in
            Thread.sleep(forTimeInterval: 2)
            Logger.shared.console("sleep 2s ok")
            
            setLabelText(text: "ok")
            hideProgress(afterDelay: 2)
        }) //leak
        
        DispatchQueue.global().async(execute: workItem)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
