//
//  SIFCardDetailCardScoreCollectionViewCell.swift
//  LLInfo
//
//  Created by CmST0us on 2018/4/3.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class SIFCardDetailCardScoreCollectionViewCell: UICollectionViewCell {
    
    enum LevelState: Int {
        case minLevel = 0
        case maxNonIdolizedLevel = 1
        case maxIdolizedLevel = 2
    }
    
    var idolizedStateChangeBlock: ((_ levelState: LevelState) -> Void)? = nil
    
    
    var hp: Int = 2 {
        didSet {
            hpLabel.text = String(hp)
        }
    }
    
    var levelState: LevelState {
        get {
            return LevelState.init(rawValue: idolizedStateSegmentedControl.selectedSegmentIndex)!
        }
        set {
            idolizedStateSegmentedControl.selectedSegmentIndex = newValue.rawValue
        }
    }
    
    // MARK: IBOutlet And IBAction
    @IBOutlet weak var pureScoreIndicator: ScoreIndicatorView!
    @IBOutlet weak var smileScoreIndicator: ScoreIndicatorView!
    @IBOutlet weak var coolScoreIndicator: ScoreIndicatorView!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var idolizedStateSegmentedControl: UISegmentedControl!
    
    @IBAction func onIdolizedStateChange(_ sender: UISegmentedControl) {
        if let block = idolizedStateChangeBlock {
            block(levelState)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let block = idolizedStateChangeBlock {
            block(levelState)
        }
    }
    
    func setupView(withUserCard userCard: UserCardDataModel, cardDataModel: CardDataModel) {
        if userCard.isIdolized {
            self.levelState = .maxIdolizedLevel
        } else {
            self.levelState = .maxNonIdolizedLevel
        }
        
        switch cardDataModel.attribute {
        case CardDataModel.Attribute.cool:
            self.idolizedStateSegmentedControl.tintColor = UIColor.coolAttribute
        case CardDataModel.Attribute.smile:
            self.idolizedStateSegmentedControl.tintColor = UIColor.smileAttribute
        case CardDataModel.Attribute.pure:
            self.idolizedStateSegmentedControl.tintColor = UIColor.pureAttribute
        case CardDataModel.Attribute.all:
            self.idolizedStateSegmentedControl.tintColor = UIColor.allAttribute
        default:
            self.idolizedStateSegmentedControl.tintColor = UIColor.aqua
        }

    }
}
