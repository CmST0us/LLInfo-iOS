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
    @IBOutlet weak var pairCardButton: UIButton!
    
    
    var pairButtonDownBlock: (() -> Void)? = nil
    
    @IBAction func onPairButtonDown(_ sender: Any) {
        if let block = pairButtonDownBlock {
            block()
        }
    }
    
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
        
        if cardDataModel.urPair == nil {
            self.viewWithTag(1)?.isHidden = true
        } else {
            self.viewWithTag(1)?.isHidden = false
            self.pairCardButton.setTitle("本卡和(ID: \(cardDataModel.urPair!.card?.id?.stringValue ?? ""))\(cardDataModel.urPair!.card?.name ?? "")是合卡", for: .normal)
        }
        
        cardIdLabel.text = cardDataModel.id.stringValue
        cardAttributeLabel.text = cardDataModel.attribute
        cardRarityLabel.text = cardDataModel.rarity
        cardReleaseDateLabel.text = cardDataModel.releaseDate

    }
}
