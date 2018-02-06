//
//  OfficialNewsListTableViewController.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/5.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import MJRefresh
import SDWebImage

final class OfficialNewsListTableViewController: UITableViewController {
    //MARK: - Private Member
    private var footerRefresh: MJRefreshFooter!
    private var headerRefresh: MJRefreshHeader!
    private lazy var officialNewsDataModelSet: NSMutableOrderedSet! = {
        let n = NSMutableOrderedSet()
        let d = ApiHelper.shared.getOfficialNewsPage(1, true)!
        let dd = DataModelHelper.shared.payloadDictionaries(withJsonData: d)!
        for obj in dd {
            let o = OfficialNewsDataModel(dictionary: obj)
            n.add(o)
        }
        return n
    }()
    
    private weak var destinationViewController: UIViewController! = nil
    
    //MARK: - Private Method
    private func initData() {
        officialNewsDataModelSet = NSMutableOrderedSet()
        do {
            if let d: Set<OfficialNewsDataModel> = try InformationCacheHelper.shared.requestPage(pageNum: 1, simpleMode: true) {
                for o in d {
                    officialNewsDataModelSet.add(o)
                }
            }
            self.sortDataOrderSet()
        } catch let e as ApiRequestError {
            self.showErrorAlert(title: "错误", message: e.message)
        } catch {
            self.showErrorAlert(title: "错误", message: error.localizedDescription)
        }
    }
    
    private func sortDataOrderSet() {
        self.officialNewsDataModelSet.sort { (a, b) -> ComparisonResult in
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
    
    @objc
    private func loadNewData() {
        DispatchQueue.global().async {
            if let firstObj = self.officialNewsDataModelSet.firstObject as? OfficialNewsDataModel {
                do {
                    if let s: Set<OfficialNewsDataModel> = try InformationCacheHelper.shared.requestInfomation(afterTimeInterval: firstObj.time!, simpleMode: true) {
                        let dataCountBeforAdd = self.officialNewsDataModelSet.count
                        for o in s {
                            self.officialNewsDataModelSet.add(o)
                        }
                        let dataCountAfterAdd = self.officialNewsDataModelSet.count
                        if dataCountBeforAdd == dataCountAfterAdd {
                            let p = OfficialNewsDataModel.requestInfomationApiParam(afterTimeInterval: firstObj.time!, simpleMode: true)
                            let data = try ApiHelper.shared.request(withParam: p)
                            if let dicts = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                                for dict in dicts {
                                    let m = OfficialNewsDataModel(dictionary: dict)
                                    InformationCacheHelper.shared.insertInformationIfNotExist(m)
                                    self.officialNewsDataModelSet.add(m)
                                }
                                try InformationCoreDataHelper.shared.saveContext()
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
            if let lastObj = self.officialNewsDataModelSet.lastObject as? OfficialNewsDataModel {
                do {
                    if let s: Set<OfficialNewsDataModel> = try InformationCacheHelper.shared.requestInfomation(beforeTimeInterval: lastObj.time!, simpleMode: true) {
                        let dataCountBeforAdd = self.officialNewsDataModelSet.count
                        for o in s {
                            self.officialNewsDataModelSet.add(o)
                        }
                        let dataCountAfterAdd = self.officialNewsDataModelSet.count
                        if dataCountBeforAdd == dataCountAfterAdd {
                            let p = OfficialNewsDataModel.requestInfomationApiParam(beforeTimeInterval: lastObj.time!, simpleMode: true)
                            let data = try ApiHelper.shared.request(withParam: p)
                            if let dicts = DataModelHelper.shared.payloadDictionaries(withJsonData: data) {
                                for dict in dicts {
                                    let m = OfficialNewsDataModel(dictionary: dict)
                                    InformationCacheHelper.shared.insertInformationIfNotExist(m)
                                    self.officialNewsDataModelSet.add(m)
                                }
                                try InformationCoreDataHelper.shared.saveContext()
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
    //MARK: - Public Member
    struct SegueId {
        static let OfficialNewsDetailSegueId = "official_news_detail_segue_id"
    }
    
    //MARK: - Public Method
    
}

// MARK: - Storyboard method
extension OfficialNewsListTableViewController {
    class func storyboardInstance() -> OfficialNewsListTableViewController {
        let storyboard = UIStoryboard(name: "InformationList", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: NSStringFromClass(self)) as! OfficialNewsListTableViewController
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case SegueId.OfficialNewsDetailSegueId:
                destinationViewController = segue.destination
                break
            default:
                break
            }
        }
    }
}

// MARK: - View life cycle method
extension OfficialNewsListTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新闻"
        self.initData()
        
        headerRefresh = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadNewData))
        footerRefresh = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadOldData))
        
        self.tableView.mj_footer = footerRefresh
        self.tableView.mj_header = headerRefresh
        
        self.tableView.separatorStyle = .none
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Table view data source method
extension OfficialNewsListTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.officialNewsDataModelSet.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = officialNewsDataModelSet[indexPath.section] as! OfficialNewsDataModel
        let cell: OfficialNewsListTableViewCell!
        if let briefImageUrl = URL(string: model.briefImageUrlPath!) {
            cell = tableView.dequeueReusableCell(withIdentifier: OfficialNewsListTableViewCell.CellId.OfficialNewsCellNormalId, for: indexPath) as! OfficialNewsListTableViewCell
            cell.briefImageImageView?.sd_setImage(with: briefImageUrl, placeholderImage: #imageLiteral(resourceName: "image_placehold"), options: SDWebImageOptions.init(rawValue: 0), completed: { (image, error, cacheType, url) in
                if let i = image {
                    if let targetCell = tableView.cellForRow(at: indexPath) as? OfficialNewsListTableViewCell {
                        targetCell.briefImageImageView?.image = i
                    }
                }
            })
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: OfficialNewsListTableViewCell.CellId.OfficialNewsCellNoImageId, for: indexPath) as! OfficialNewsListTableViewCell
        }
        
        cell.setupCell(withInfoDataModel: model)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataModelOfSelectCell = officialNewsDataModelSet[indexPath.section]
        let dest = destinationViewController as! InformationDetailViewController
        dest.setup(withInformationDataModel: dataModelOfSelectCell as! OfficialNewsDataModel)
    }
}
