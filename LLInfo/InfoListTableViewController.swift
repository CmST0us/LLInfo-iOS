//
//  InfoListTableViewController.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/3.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import SDWebImage
import MJRefresh
class InfoListTableViewController: UITableViewController {
    
    struct SegueId {
        static let infoDetailSegueId = "info_detail_segue_id"
    }
    
    //MARK: - Private Member
    private weak var destinationViewController: UIViewController? = nil
    private var infoListDataSet: NSMutableOrderedSet! = nil
    private var footerRefresh: MJRefreshFooter!
    private var headerRefresh: MJRefreshHeader!
    
    //MARK: - Private Method
    private func sortDataOrderSet() {
        self.infoListDataSet.sort { (a, b) -> ComparisonResult in
            if let a = a as? InformationDataModel, let b = b as? InformationDataModel {
                if a.time! > b.time! {
                    return ComparisonResult.orderedAscending
                } else if a.time! < b.time! {
                    return ComparisonResult.orderedDescending
                } else {
                    return ComparisonResult.orderedSame
                }
            }
            return ComparisonResult.orderedSame
        }
    }
    
    private func initData() {
        infoListDataSet = NSMutableOrderedSet()
        do {
            if let d: Set<InfoDataModel> = try InformationCacheHelper.shared.requestPage(pageNum: 1, simpleMode: true) {
                for o in d {
                    infoListDataSet.add(o)
                }
            }
            self.sortDataOrderSet()
        } catch let e as ApiRequestError {
            self.showErrorAlert(title: "错误", message: e.message)
        } catch {
            self.showErrorAlert(title: "错误", message: error.localizedDescription)
        }
    }
    
    @objc
    private func loadNewData() {
        DispatchQueue.global().async {
            if let firstObj = self.infoListDataSet.firstObject as? InfoDataModel {
                do {
                    if let s: Set<InfoDataModel> = try InformationCacheHelper.shared.requestInfomation(afterTimeInterval: firstObj.time!, simpleMode: true) {
                        let dataCountBeforAdd = self.infoListDataSet.count
                        for o in s {
                            self.infoListDataSet.add(o)
                        }
                        let dataCountAfterAdd = self.infoListDataSet.count
                        if dataCountBeforAdd == dataCountAfterAdd {
                            let p = InfoDataModel.requestInfomationApiParam(afterTimeInterval: firstObj.time!, simpleMode: true)
                            let data = try ApiHelper.shared.request(withParam: p)
                            if let dicts = DataModelHelper.shared.createDictionaries(withJsonData: data) {
                                for dict in dicts {
                                    let m = InfoDataModel(dictionary: dict)
                                    InformationCacheHelper.shared.insertInformationIfNotExist(m)
                                    self.infoListDataSet.add(m)
                                }
                                try CoreDataHelper.shared.saveContext()
                            }
                        }
                        self.sortDataOrderSet()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch let e as ApiRequestError {
                    self.showErrorAlert(title: "错误", message: e.message)
                } catch {
                    self.showErrorAlert(title: "错误", message: error.localizedDescription)
                }
            } else {
                self.initData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.tableView.mj_header.endRefreshing()
            }
        }
    }
    
    @objc
    private func loadOldData() {
        DispatchQueue.global().async {
            if let lastObj = self.infoListDataSet.lastObject as? InfoDataModel {
                do {
                    if let s: Set<InfoDataModel> = try InformationCacheHelper.shared.requestInfomation(beforeTimeInterval: lastObj.time!, simpleMode: true) {
                        let dataCountBeforAdd = self.infoListDataSet.count
                        for o in s {
                            self.infoListDataSet.add(o)
                        }
                        let dataCountAfterAdd = self.infoListDataSet.count
                        if dataCountBeforAdd == dataCountAfterAdd {
                            let p = InfoDataModel.requestInfomationApiParam(beforeTimeInterval: lastObj.time!, simpleMode: true)
                            let data = try ApiHelper.shared.request(withParam: p)
                            if let dicts = DataModelHelper.shared.createDictionaries(withJsonData: data) {
                                for dict in dicts {
                                    let m = InfoDataModel(dictionary: dict)
                                    InformationCacheHelper.shared.insertInformationIfNotExist(m)
                                    self.infoListDataSet.add(m)
                                }
                                try CoreDataHelper.shared.saveContext()
                            }
                        }
                        self.sortDataOrderSet()
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch let e as ApiRequestError {
                    self.showErrorAlert(title: "错误", message: e.message)
                } catch {
                    self.showErrorAlert(title: "错误", message: error.localizedDescription)
                }
            } else {
                self.initData()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.tableView.mj_footer.endRefreshing()
            }
        }
    }
    
    private func checkNewVersion() {
        let infoDic = Bundle.main.infoDictionary!
        // 获取App的版本号
        if let appVersionString = infoDic["CFBundleShortVersionString"] as? String {
            if let appVersion = Float(appVersionString) {
                let param = AppVersionUpdateDataModel.requestApiParam()
                do {
                    let data = try ApiHelper.shared.request(withParam: param)
                    if let d = DataModelHelper.shared.createDictionaries(withJsonData: data) {
                        let appVerModel = AppVersionUpdateDataModel(dictionary: d[0])
                        if let nv = appVerModel.version {
                            if appVersion < nv {
                                DispatchQueue.main.async {
                                    let alert = UIAlertController(title: "检测到新版本", message: appVerModel.message ?? "请前往App Store下载更新", preferredStyle: .alert)
                                    let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                    alert.addAction(cancel)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        headerRefresh = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadNewData))
        footerRefresh = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadOldData))
        
        self.tableView.mj_footer = footerRefresh
        self.tableView.mj_header = headerRefresh
        
        self.tableView.separatorStyle = .none
        
        DispatchQueue.global().async {
            self.checkNewVersion()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let dataCount = infoListDataSet.count
        if dataCount != 0 {
            tableView.separatorStyle = .singleLine
        } else {
            tableView.separatorStyle = .none
        }
        return dataCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InfoListTableViewCell.CellId.infoListCellId, for: indexPath) as! InfoListTableViewCell

        let model = infoListDataSet.object(at: indexPath.row) as! InfoDataModel
        cell.setupCell(withInfoDataModel: model)
        
        cell.briefImageImageView.sd_setImage(with: URL.init(string: model.briefImageUrlPath ?? ""), placeholderImage: #imageLiteral(resourceName: "image_placehold"), options: .retryFailed) { (image, error, cacheType, url) in
            if let im = image {
                if let targetCell = tableView.cellForRow(at: indexPath) as? InfoListTableViewCell {
                    targetCell.briefImageImageView.image = im
                }
            }
        }
        
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataModelOfSelectCell = infoListDataSet[indexPath.row]
        let dest = destinationViewController as! InformationDetailViewController
        dest.setup(withInformationDataModel: dataModelOfSelectCell as! InfoDataModel)
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case SegueId.infoDetailSegueId:
                destinationViewController = segue.destination
                break
            default:
                break
            }
        }
    }
    

}
