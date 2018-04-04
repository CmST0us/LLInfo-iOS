//
//  SIFCardDetailCardScoreCollectionViewCell.swift
//  LLInfo
//
//  Created by CmST0us on 2018/4/3.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class SIFCardDetailCardScoreCollectionViewCell: UICollectionViewCell {
    
    // MARK: IBOutlet And IBAction
    @IBOutlet weak var rankTextField: UITextField!
    @IBOutlet weak var pureScoreIndicator: ScoreIndicatorView!
    @IBOutlet weak var smileScoreIndicator: ScoreIndicatorView!
    @IBOutlet weak var coolScoreIndicator: ScoreIndicatorView!
    @IBOutlet weak var lifeLabel: UILabel!
    
    @IBAction func onRankChange(_ sender: Any) {
        
    }
}
