//
//  MyCollectionViewController.swift
//  LLInfo
//
//  Created by CmST0us on 2017/11/14.
//  Copyright © 2017年 eki. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cell_with_image"
private let reuseIdentifier2 = "cell_without_image"

class MyCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var infoData: [MyInfoDataModel] = [MyInfoDataModel]()
    
    var refreshControl: UIRefreshControl?
    var loadMoreControl: UIRefreshControl?
    
    func fetchInfos() {
        MyInfoFetcher.fetchInfo(withUrl: URL(string: "https://hk.cmst0us.me/infos/page/1")!, updateHandler: { (infos) in
            self.infoData = infos
            DispatchQueue.main.async {
                let flowLayout: UICollectionViewFlowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
                flowLayout.estimatedItemSize = CGSize(width: self.view.frame.size.width, height: 100)
                self.collectionView?.reloadData()
            }
        })
    }
    
    private func _setupView() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(MyCollectionViewController._refreshData), for: .valueChanged)
        self.collectionView?.addSubview(refreshControl!)
    }
    
    @objc
    private func _refreshData() {
        self.refreshControl?.endRefreshing()
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        self.collectionView?.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        
        let flowLayout: UICollectionViewFlowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.estimatedItemSize = CGSize(width: self.view.frame.size.width, height: 100)
        
        self._setupView()
        self.fetchInfos()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case "frame"?:
            let flowLayout: UICollectionViewFlowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.estimatedItemSize = CGSize(width: self.view.frame.size.width, height: 100)
            break
            
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.infoData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        let info = self.infoData[indexPath.row]
        cell.setupCellWithInfoData(info)
        return cell
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
