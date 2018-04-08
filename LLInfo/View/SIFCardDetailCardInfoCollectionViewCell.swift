//
//  SIFCardDetailCardInfoCollectionViewCell.swift
//  LLInfo
//
//  Created by CmST0us on 2018/4/3.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class SIFCardDetailCardInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cardTypeLabel: UILabel!
    @IBOutlet weak var cardIdLabel: UILabel!
    @IBOutlet weak var cardAttributeLabel: UILabel!
    @IBOutlet weak var cardRarityLabel: UILabel!
    @IBOutlet weak var cardReleaseDateLabel: UILabel!
    
    func setupView(withUserCard userCard: UserCardDataModel, cardDataModel: CardDataModel) {
        var typeString = "此卡"
        if cardDataModel.isPromo?.boolValue ?? false {
            typeString += "为特典卡 "
        }
        if cardDataModel.japanOnly?.boolValue ?? true {
            typeString += "只在日服有"
        }
        if typeString.count == 2 {
            cardTypeLabel.isHidden = true
        } else {
            cardTypeLabel.isHidden = false
            cardTypeLabel.text = typeString
        }
        
        cardIdLabel.text = cardDataModel.id.stringValue
        cardAttributeLabel.text = cardDataModel.attribute
        cardRarityLabel.text = cardDataModel.rarity
        cardReleaseDateLabel.text = cardDataModel.releaseDate

    }
}
