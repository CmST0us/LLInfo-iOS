//
//  SIFUserCardCollectionViewCell.swift
//  SIFTool
//
//  Created by CmST0us on 2018/3/6.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class SIFUserCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardRoundImageView: UIImageView!
    @IBOutlet weak var rarityNameIdLabel: UILabel!
    @IBOutlet weak var idolizedKizunaLabel: UILabel!
    
    @IBOutlet weak var smileIndicatorView: ScoreIndicatorView!
    @IBOutlet weak var coolScoreIndicatorView: ScoreIndicatorView!
    @IBOutlet weak var pureScoreIndicatorView: ScoreIndicatorView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteHandle: ((_ : UIButton) -> Void)? = nil
    
    @IBAction func onDeleteButtonDown(_ sender: UIButton) {
        
        if let handle = deleteHandle {
            handle(sender)
        }
        
    }
    
    func setupCardRoundImageView(withCard card: CardDataModel, idolized: Bool) {
        cardRoundImageView.image = SIFCacheHelper.shared.image(withUrl: URL(string: (idolized ? card.roundCardIdolizedImage : card.roundCardImage) ?? ""))
    }
    
    func setupIdolizedKizunaLabel(isKizunaMax: Bool, isIdolized: Bool) {
        let kizunaMaxString = isKizunaMax ? "绊满" : "绊0"
        let idolizedString = isIdolized ? "已觉醒" : "未觉醒"
        
        if idolizedKizunaLabel != nil {
            idolizedKizunaLabel.text = (kizunaMaxString + " " + idolizedString)
        }
    }
    
    func setupScoreIndicator(withCard card: CardDataModel, isKizunaMax: Bool, isIdolized: Bool)  {
        smileIndicatorView.maxScore = CardDataModel.maxCardScore
        smileIndicatorView.score = card.statisticsSmile(idolized: isIdolized, isKizunaMax: isKizunaMax).doubleValue
        
        coolScoreIndicatorView.maxScore = CardDataModel.maxCardScore
        coolScoreIndicatorView.score = card.statisticsCool(idolized: isIdolized, isKizunaMax: isKizunaMax).doubleValue
        
        pureScoreIndicatorView.maxScore = CardDataModel.maxCardScore
        pureScoreIndicatorView.score = card.statisticsPure(idolized: isIdolized, isKizunaMax: isKizunaMax).doubleValue
    }
    
    func setupView(withCard: CardDataModel, userCard: UserCardDataModel) {
        setupCardRoundImageView(withCard: withCard, idolized: userCard.isIdolized)
        setupIdolizedKizunaLabel(isKizunaMax: userCard.isKizunaMax, isIdolized: userCard.isIdolized)
        
        rarityNameIdLabel.text = "\(withCard.rarity) \(withCard.idol.japaneseName ?? withCard.idol.englishName) (\(String(withCard.id.intValue)))"
        
        setupScoreIndicator(withCard: withCard, isKizunaMax: userCard.isKizunaMax, isIdolized: userCard.isIdolized)
    }
    
}

