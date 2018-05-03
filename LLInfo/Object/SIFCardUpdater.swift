//
//  SIFCardUpdater.swift
//  LLInfo
//
//  Created by CmST0us on 2018/5/3.
//  Copyright © 2018年 eki. All rights reserved.
//

import Foundation


class SIFCardUpdater {
    
    weak var delegate: SIFCardUpdaterDelegate? = nil
    
    private var workItem: DispatchWorkItem? = nil
    
    var queue: DispatchQueue
    
    init(withWorkQueue workQueue: DispatchQueue) {
        queue = workQueue
        
    }
    
    init() {
        queue = DispatchQueue.main
    }
    
    private func checkCardUpdate() -> Bool {
        let param = CardDataModel.requestIds()
        if let recvData = try? SchoolIdolTomotachiApiHelper.shared.request(withParam: param) {
            if let jsonArray = DataModelHelper.shared.array(withJsonData: recvData) as? [Int] {
                return !(jsonArray.count == SIFCacheHelper.shared.cards.count)
            }
        }
        return false
    }
    
    func startUpdateCard(inQueue queue: DispatchQueue) {
        workItem = DispatchWorkItem(block: { [weak self] in
            // start check card update
            if let weakSelf = self {
                weakSelf.delegate?.updaterWillUpdateCard(weakSelf)
                do {
                    try SIFCacheHelper.shared.cacheCards(process: { (current, total) in
                        if weakSelf.workItem!.isCancelled {
                            weakSelf.delegate?.updaterWillCancelByUser(weakSelf)
                            
                            var stopError = SIFCacheHelperError()
                            stopError.code = .stopByUser
                            throw stopError
                        }
                        weakSelf.delegate?.updaterDidUpdateCard(weakSelf, currentCardCount: current, totalCardCount: total)
                    })
                } catch {
                    weakSelf.delegate?.updaterDidFinishUpdateCard(weakSelf, success: false)
                    return
                }
                weakSelf.delegate?.updaterWillStartUpdateCardRoundImage(weakSelf)
                SIFCacheHelper.shared.cacheAllRoundCardImage()
                weakSelf.delegate?.updaterDidFinishUpdateCard(weakSelf, success: true)
            }
        })
        queue.async(execute: workItem!)
    }
    
    func startCheckCardUpdate(inQueue queue: DispatchQueue) {
        queue.async { [weak self] in
            if let weakSelf = self {
                weakSelf.delegate?.updaterWillStartCheckCardUpdate(weakSelf)
                if weakSelf.checkCardUpdate() {
                    // have new cards
                    weakSelf.delegate?.updaterDidFindNewCard(weakSelf)
                }
            }
        }
    }
    
    func startCheckCardUpdate() {
        startCheckCardUpdate(inQueue: self.queue)
    }
    
    func startUpdateCard() {
        startUpdateCard(inQueue: self.queue)
    }
    
    func stopUpdateCard() {
        workItem?.cancel()
    }
}
