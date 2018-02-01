//
//  DetailTableViewController.swift
//  testHostApp
//
//  Created by CmST0us on 2018/1/8.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    var dataDictionary: Dictionary<String, Any>! = nil
    
    private lazy var keysAndValues: [[Any]] = {
        var a = [[Any]]()
        for (key, value) in dataDictionary {
            a.append([key, value])
        }
        return a
    }()
    
    @IBAction func addNew(_ sender: Any) {
        for i in 0 ..< keysAndValues.count {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! DetailTableViewCell
            let key = keysAndValues[i][0] as! String
            if key == "time" {
                if let value = TimeInterval(cell.valueTextField.text!) {
                    dataDictionary[key] = NSNumber(value: value)
                } else {
                    let a = UIAlertController(title: "错误", message: "时间格式错误", preferredStyle: .alert)
                    let c = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    a.addAction(c)
                    self.present(a, animated: true, completion: nil)
                    return
                }
                
            } else {
                let value = cell.valueTextField.text
                dataDictionary[key] = value
            }
        }
        InformationCacheHelper.shared.insertInformationIfNotExist(InfoDataModel(dictionary: dataDictionary))
        do {
            try CoreDataHelper.shared.saveContext()
            let a = UIAlertController(title: "保存", message: "成功", preferredStyle: .alert)
            let c = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            a.addAction(c)
            self.present(a, animated: true, completion: nil)
        } catch {
            let a = UIAlertController(title: "错误", message: "error: \(error))", preferredStyle: .alert)
            let c = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            a.addAction(c)
            self.present(a, animated: true, completion: nil)
        }

    }
    @IBAction func saveChange() {
        for i in 0 ..< keysAndValues.count {
            let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as! DetailTableViewCell
            let key = keysAndValues[i][0] as! String
            if key == "time" {
                if let value = TimeInterval(cell.valueTextField.text!) {
                    dataDictionary[key] = NSNumber(value: value)
                } else {
                    let a = UIAlertController(title: "错误", message: "时间格式错误", preferredStyle: .alert)
                    let c = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    a.addAction(c)
                    self.present(a, animated: true, completion: nil)
                    return
                }
                
            } else {
                let value = cell.valueTextField.text
                dataDictionary[key] = value
            }
        }
        
        let m = InfoDataModel(dictionary: dataDictionary)
        if InformationCacheHelper.shared.update(information: m, usingUrlPath: m.urlPath!, valuesAndKeys: dataDictionary) == false {
            let a = UIAlertController(title: "错误", message: "保存失败", preferredStyle: .alert)
            let c = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            a.addAction(c)
            self.present(a, animated: true, completion: nil)
        }
        
        do {
            try CoreDataHelper.shared.saveContext()
            let a = UIAlertController(title: "保存", message: "成功", preferredStyle: .alert)
            let c = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            a.addAction(c)
            self.present(a, animated: true, completion: nil)
        } catch {
            let a = UIAlertController(title: "错误", message: "error: \(error))", preferredStyle: .alert)
            let c = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            a.addAction(c)
            self.present(a, animated: true, completion: nil)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return keysAndValues.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailTableViewCell
        let key = keysAndValues[indexPath.row][0] as! String
        if key == InfoDataModel.CodingKey.time {
            let value = keysAndValues[indexPath.row][1] as? NSNumber
            cell.setupCell(withKey: key, value: value?.stringValue)
        } else if key == InfoDataModel.CodingKey.tags {
            let value = keysAndValues[indexPath.row][1] as? [String]
            cell.setupCell(withKey: key, value: value?.joined(separator: "||"))
        } else {
            let value = keysAndValues[indexPath.row][1] as? String
            cell.setupCell(withKey: key, value: value)
        }
        
        return cell
    }
 
    

}
