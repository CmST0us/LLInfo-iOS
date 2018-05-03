//
//  SIFCardUpdaterDelegate.swift
//  LLInfo
//
//  Created by CmST0us on 2018/5/3.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation

protocol SIFCardUpdaterDelegate: NSObjectProtocol {
    func updaterWillStartCheckCardUpdate(_ updater: SIFCardUpdater)
    func updaterDidFindNewCard(_ updater: SIFCardUpdater)
    func updaterWillUpdateCard(_ updater: SIFCardUpdater)
    func updaterDidUpdateCard(_ updater: SIFCardUpdater, currentCardCount: Int, totalCardCount: Int)
    
    func updaterWillCancelByUser(_ updater: SIFCardUpdater)
    func updaterDidFinishUpdateCard(_ updater: SIFCardUpdater, success: Bool)

}
