//
//  ExplorerTableViewController.swift
//  testHostApp
//
//  Created by CmST0us on 2018/1/8.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import CoreData

import MJRefresh
import SDWebImage


class ExplorerTableViewController: UITableViewController {
    
    var destinationViewController: UIViewController! = nil
    private var footerRefresh: MJRefreshFooter!
    private var headerRefresh: MJRefreshHeader!
    
    private lazy var dataOrderSet: NSMutableOrderedSet! = {
        do {
            if let os: Set<InfoDataModel> = try InformationCacheHelper.shared.requestPage(pageNum: 1, simpleMode: true) {
                return NSMutableOrderedSet(set: os)
            }
        } catch {
            self.showErrorAlert(title: "Error", message: "init dataOrderSet Faild")
        }
        return NSMutableOrderedSet()
    }()
    
    @IBAction func dumpfa(_ sender: Any) {
        if let s = UserDataHelper.shared.fetchFavorite() {
            print("count: \(s.count)")
            for o in s {
                print("type: \(o.type), url: \(o.url)")
            }
        }
    }
    private func sortDataOrderSet() {
        self.dataOrderSet.sort { (a, b) -> ComparisonResult in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerRefresh = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(self.loadNewData))
        footerRefresh = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(self.loadOldData))
        
        self.tableView.mj_footer = footerRefresh
        self.tableView.mj_header = headerRefresh
        
    }
    @IBAction func dumpDataBase(_ sender: Any) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: InfoDataModel.entityName)
        fetch.resultType = .dictionaryResultType
        let sort = NSSortDescriptor(key: "time", ascending: false)
        fetch.sortDescriptors = [sort]
        let context = InformationCoreDataHelper.shared.persistentContainer.viewContext
        do {
            let res = try context.fetch(fetch) as! [Dictionary<String, Any>]
            for d in res {
                print(d)
                print("\n\n\n")
            }
            print("count: \(res.count)")
        } catch {
            print("error dump")
        }
    }
    
    @IBAction func reloadData(_ sender: Any) {
        dataOrderSet.removeAllObjects()
        if let os: Set<InfoDataModel> = try! InformationCacheHelper.shared.fetchInformation(limit: 20, offset: 0) {
            self.dataOrderSet = NSMutableOrderedSet(set: os)
        }
        sortDataOrderSet()
        self.tableView.reloadData()
    }
    @objc private func loadNewData() {
        DispatchQueue.global().async {
            if let firstObj = self.dataOrderSet.firstObject as? InfoDataModel {
                if let s: Set<InfoDataModel> = try! InformationCacheHelper.shared.requestInfomation(afterTimeInterval: firstObj.time!, simpleMode: true) {
                    for o in s {
                        self.dataOrderSet.add(o)
                    }
                    self.sortDataOrderSet()
                    try! InformationCoreDataHelper.shared.saveContext()
                    DispatchQueue.main.async {
                        self.tableView.mj_header.endRefreshing()
                        self.tableView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.mj_header.endRefreshing()
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.mj_header.endRefreshing()
                }
            }
        }
    }
    
    @objc
    private func loadOldData() {
        DispatchQueue.global().async {
            if let lastObj = self.dataOrderSet.lastObject as? InfoDataModel {
                if let s: Set<InfoDataModel> = try! InformationCacheHelper.shared.requestInfomation(beforeTimeInterval: lastObj.time!, simpleMode: true) {
                    for o in s {
                        self.dataOrderSet.add(o)
                    }
                    self.sortDataOrderSet()
                    try! InformationCoreDataHelper.shared.saveContext()
                    DispatchQueue.main.async {
                        self.tableView.mj_footer.endRefreshing()
                        self.tableView.reloadData()
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.mj_footer.endRefreshing()
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.mj_footer.endRefreshing()
                }
            }
        }
    }
    @IBAction func removeAll(_ sender: Any) {
        let a = UIAlertController(title: "清空数据库", message: "确定吗？", preferredStyle: .alert)
        let o = UIAlertAction(title: "确定", style: .default) { (alert) in
            InformationCacheHelper.shared.removeAll(inEntity: "Info")
            try! InformationCoreDataHelper.shared.saveContext()
            self.dataOrderSet.removeAllObjects()
            self.tableView.reloadData()
        }
        let c = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        a.addAction(o)
        a.addAction(c)
        self.present(a, animated: true, completion: nil)
        
    }
    
    @IBAction func getDataFromServer(_ sender: Any) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        self.title = String(dataOrderSet.count)
        return dataOrderSet.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let m = dataOrderSet[indexPath.row] as! InfoDataModel
        cell.textLabel?.text = m.title?.trimmingCharacters(in: .whitespacesAndNewlines)
        cell.detailTextLabel?.text = m.formatTime
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let d = destinationViewController as! DetailTableViewController
        let m = dataOrderSet[indexPath.row] as! InfoDataModel
        d.dataDictionary = m.dataDictionary
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let m = dataOrderSet[indexPath.row] as! InfoDataModel
        let _ = InformationCacheHelper.shared.removeInformation(byUrlPath: m.urlPath!, information: m)
        dataOrderSet.removeObject(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        try! InformationCoreDataHelper.shared.saveContext()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "detail":
                destinationViewController = segue.destination
                break
            case "add":
                let dest = segue.destination as! DetailTableViewController
                dest.dataDictionary = [
                    InfoDataModel.CodingKey.id: "",
                    InfoDataModel.CodingKey.title: "",
                    InfoDataModel.CodingKey.brief: "",
                    InfoDataModel.CodingKey.tags: "",
                    InfoDataModel.CodingKey.contentHtml: "",
                    InfoDataModel.CodingKey.source: "",
                    InfoDataModel.CodingKey.sourceName: "",
                    InfoDataModel.CodingKey.time: "",
                    InfoDataModel.CodingKey.briefImageUrl: "",
                    InfoDataModel.CodingKey.url: ""
                ]
                break
            default:
                break
            }
        }
    }
    

}
