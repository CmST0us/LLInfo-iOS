//
//  OfficalNewsListTableViewController.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/5.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import MJRefresh
import SDWebImage

class OfficalNewsListTableViewController: UITableViewController {
    //MARK: - Private Member
    private var footerRefresh: MJRefreshFooter!
    private var headerRefresh: MJRefreshHeader!
    private lazy var officalNewsDataModelSet: NSMutableOrderedSet! = {
        //mock
        let n = NSMutableOrderedSet()
        let d = ApiHelper.shared.getOfficalNewsPage(1, true)!
        let dd = DataModelHelper.shared.createDictionaries(withJsonData: d)!
        for obj in dd {
            let o = OfficalNewsDataModel(dictionary: obj)
            n.add(o)
        }
        return n
    }()
    private weak var destinationViewController: UIViewController! = nil
    
    
    struct SegueId {
        static let officalNewsDetailSegueId = "offical_news_detail_segue_id"
    }
    

    
    //MARK: - Private Method
    private func initData() {
        self.officalNewsDataModelSet = NSMutableOrderedSet()
        if let d = ApiHelper.shared.getOfficalNewsPage(1, true) {
            if let dict = DataModelHelper.shared.createDictionaries(withJsonData: d) {
                for o in dict {
                    let model = OfficalNewsDataModel(dictionary: o)
                    self.officalNewsDataModelSet.add(model)
                }
            }
        }
    }
    
    @objc private func loadNewData() {
        DispatchQueue.global().async {
            if let firstObj = self.officalNewsDataModelSet.firstObject as? OfficalNewsDataModel {
                if let data = ApiHelper.shared.getOfficalNews(afterTimeInterval: firstObj.time!, true) {
                    if let json = DataModelHelper.shared.createDictionaries(withJsonData: data) {
                        for j in json {
                            let m = OfficalNewsDataModel(dictionary: j)
                            self.officalNewsDataModelSet.insert(m, at: 0)
                        }
                        DispatchQueue.main.async {
                            self.tableView.mj_header.endRefreshing()
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.tableView.mj_header.endRefreshing()
                    }
                }
            } else {
                self.initData()
                DispatchQueue.main.async {
                    self.tableView.mj_header.endRefreshing()
                }
            }
            
        }
    }
    
    @objc
    private func loadOldData() {
        DispatchQueue.global().async {
            if let lastObj = self.officalNewsDataModelSet.lastObject as? OfficalNewsDataModel {
                if let data = ApiHelper.shared.getOfficalNews(beforeTimeInterval: lastObj.time!, true) {
                    if let json = DataModelHelper.shared.createDictionaries(withJsonData: data) {
                        for j in json {
                            let m = OfficalNewsDataModel(dictionary: j)
                            self.officalNewsDataModelSet.add(m)
                        }
                        DispatchQueue.main.async {
                            self.tableView.mj_footer.endRefreshing()
                            self.tableView.reloadData()
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.tableView.mj_footer.endRefreshing()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.mj_footer.endRefreshing()
                }
            }
        }
    }
    //MARK: - Public Member
    
    
    //MARK: - Public Method
    
    
    //Mark: - View Life Cycle
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.officalNewsDataModelSet.count
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
        let model = officalNewsDataModelSet[indexPath.section] as! OfficalNewsDataModel
        let cell: OfficalNewsListTableViewCell!
        if let briefImageUrl = URL(string: model.briefImageUrlPath!) {
            cell = tableView.dequeueReusableCell(withIdentifier: OfficalNewsListTableViewCell.CellId.officalNewsCellNormalId, for: indexPath) as! OfficalNewsListTableViewCell
            cell.briefImageImageView?.sd_setImage(with: briefImageUrl, placeholderImage: #imageLiteral(resourceName: "image_placehold"), options: SDWebImageOptions.init(rawValue: 0), completed: { (image, error, cacheType, url) in
                if let i = image {
                    if let targetCell = tableView.cellForRow(at: indexPath) as? OfficalNewsListTableViewCell {
                        targetCell.briefImageImageView?.image = i
                    }
                }
            })
            
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: OfficalNewsListTableViewCell.CellId.officalNewsCellNoImageId, for: indexPath) as! OfficalNewsListTableViewCell
        }
        
        cell.setupCell(withInfoDataModel: model)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataModelOfSelectCell = officalNewsDataModelSet[indexPath.section]
        let dest = destinationViewController as! InfoDetailViewController
        dest.setup(withInformationDataModel: dataModelOfSelectCell as! OfficalNewsDataModel)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let segueIdentifier = segue.identifier {
            switch segueIdentifier {
            case SegueId.officalNewsDetailSegueId:
                destinationViewController = segue.destination
                break
            default:
                break
            }
        }
    }


}
