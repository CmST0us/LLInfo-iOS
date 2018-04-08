//
//  SIFCardDetailIdolCollectionViewCell.swift
//  LLInfo
//
//  Created by CmST0us on 2018/4/3.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class SIFCardDetailIdolCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var idolJapneseNameLabel: UILabel!
    @IBOutlet weak var idolEnglishNameLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var subUnitLabel: UILabel!
    @IBOutlet weak var mainUnitLabel: UILabel!
    
    func setupView(withUserCard: UserCardDataModel, cardDataModel: CardDataModel) {
        self.idolJapneseNameLabel.text = cardDataModel.idol.japaneseName
        self.idolEnglishNameLabel.text = cardDataModel.idol.englishName
        self.schoolLabel.text = cardDataModel.idol.school
        self.yearLabel.text = cardDataModel.idol.year
        self.subUnitLabel.text = cardDataModel.idol.subUnit
        self.mainUnitLabel.text = cardDataModel.idol.mainUnit
    }
}
