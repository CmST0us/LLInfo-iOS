//
//  SIFCardDetailCardSkillCollectionViewCell.swift
//  LLInfo
//
//  Created by CmST0us on 2018/4/3.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class SIFCardDetailCardSkillCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var skillNameLabel: UILabel!
    
    @IBOutlet weak var skillDetailLabel: UILabel!
    
    @IBOutlet weak var centerSkillNameLabel: UILabel!
    
    @IBOutlet weak var centerSkillDetailLabel: UILabel!
    
    func setupView(withUserCard userCard: UserCardDataModel, cardDataModel: CardDataModel) {
        skillNameLabel.text = cardDataModel.japaneseSkill ?? cardDataModel.skill
        skillDetailLabel.text = cardDataModel.japaneseSkillDetails ?? cardDataModel.skillDetails
        centerSkillNameLabel.text = cardDataModel.japaneseCenterSkill ?? cardDataModel.centerSkill
        centerSkillDetailLabel.text = cardDataModel.japaneseCenterSkillDetails ?? cardDataModel.centerSkillDetails
    }
}
