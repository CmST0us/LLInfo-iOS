//
//  SettingTableViewController.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/6.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import MessageUI
import MJRefresh
import SDWebImage

class SettingTableViewController: UITableViewController{
    
    
}

// MARK: - View life cycle method
extension SettingTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
    }
}


// MARK: - Table view delegate method
extension SettingTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.tuple {
        case (0, 0):
            //del cache
            let alert = UIAlertController(title: "清理图片缓存", message: "是否确定删除图片缓存", preferredStyle: .alert)
            let alertCancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let alertCleanAction = UIAlertAction(title: "清理", style: .default, handler: { (action) in
                SDImageCache.shared().clearDisk(onCompletion: {
                    let finishAlert = UIAlertController(title: "清理图片缓存", message: "清理成功", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "好的", style: .cancel, handler: nil)
                    finishAlert.addAction(cancel)
                    self.present(finishAlert, animated: true, completion: nil)
                })
            })
            alert.addAction(alertCancelAction)
            alert.addAction(alertCleanAction)
            self.present(alert, animated: true, completion: nil)
            break
        case (0, 1):
            //del core data
            let alert = UIAlertController(title: "清理情报缓存", message: "是否确定删除情报缓存", preferredStyle: .alert)
            let alertCancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let alertCleanAction = UIAlertAction(title: "清理", style: .default, handler: { (action) in
                do {
                    InformationCacheHelper.shared.removeAll(inEntity: InfoDataModel.entityName)
                    InformationCacheHelper.shared.removeAll(inEntity: OfficialNewsDataModel.entityName)
                    try InformationCoreDataHelper.shared.saveContext()
                    let finishAlert = UIAlertController(title: "清理情报缓存", message: "清理成功", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "好的", style: .cancel, handler: nil)
                    finishAlert.addAction(cancel)
                    self.present(finishAlert, animated: true, completion: nil)
                } catch {
                    self.showErrorAlert(title: "错误", message: error.localizedDescription)
                }
            })
            alert.addAction(alertCancelAction)
            alert.addAction(alertCleanAction)
            self.present(alert, animated: true, completion: nil)
            break
        case (1, 1):
            //about
            let about = UIAlertController(title: "关于", message: "本App仅抓取网站情报数据，并不对情报真实性做甄别\n如果本App侵犯了您的权益，请在使用反馈中邮件联系我们，谢谢\n@eki", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            about.addAction(cancel)
            self.present(about, animated: true, completion: nil)
            break
        case (1, 2):
            //mail to developer
            guard MFMailComposeViewController.canSendMail() else {
                
                let alert = UIAlertController(title: "使用反馈", message: "您的设备尚未设置邮箱，请在“邮件”应用中设置后再尝试发送。", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "好的", style: .default, handler: nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            let mailVC = MFMailComposeViewController()
            mailVC.setToRecipients(["eki3u@outlook.com"])
            mailVC.setSubject("爱生活与情报-使用反馈")
            mailVC.mailComposeDelegate = self
            
            let infoDic = Bundle.main.infoDictionary
            
            // 获取App的版本号
            let appVersion = infoDic?["CFBundleShortVersionString"]
            //获取系统版本号
            let systemVersion = UIDevice.current.systemVersion
            //获取设备的型号
            let deviceModel = UIDevice.current.modelName
            
            let s = """
            
            
            
            
            App版本：\(appVersion!)
            系统版本号: \(systemVersion)
            设备型号: \(deviceModel)
            """
            mailVC.setMessageBody(s, isHTML: false)
            self.present(mailVC, animated: true, completion: nil)
            break
        default:
            break
        }
    }
}

extension SettingTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
        switch result {
        case .sent:
            let alert = UIAlertController(title: "使用反馈", message: "感谢您的反馈！", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            break
        default:
            break
        }
        
    }
}
