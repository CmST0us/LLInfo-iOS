//
//  UICollectionViewController+ReloadDataAsync.swift
//  LLInfo
//
//  Created by CmST0us on 2018/5/2.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

extension UICollectionView {
    func reloadDataAsync() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
