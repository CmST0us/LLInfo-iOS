//
//  SIFCardImportCollectionViewCell.swift
//  SIFTool
//
//  Created by CmST0us on 2018/3/14.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class SIFCardImportCollectionViewCell: SIFUserCardCollectionViewCell {

    var isKizunaMax: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {
                if self.isKizunaMax {
                    self.isKizunaMaxButton.backgroundColor = UIColor.buttonOn
                } else {
                    self.isKizunaMaxButton.backgroundColor = UIColor.buttonOff
                }
            })
        }
    }
    
    var isIdolized: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {
                if self.isIdolized {
                    self.isIdolizedButton.backgroundColor = UIColor.buttonOn
                } else {
                    self.isIdolizedButton.backgroundColor = UIColor.buttonOff
                }
            })
        }
    }
    
    var isImport: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.2, animations: {
                if self.isImport {
                    self.isImportButton.backgroundColor = UIColor.buttonOn
                } else {
                    self.isImportButton.backgroundColor = UIColor.buttonOff
                }
            })
        }
    }
    
    var valueChangeHandle: (((isImport: Bool, isIdolized: Bool, isKizunaMax: Bool, cell: SIFCardImportCollectionViewCell)) -> Void)? = nil
    
    @IBOutlet weak var isKizunaMaxButton: UIButton!
    
    @IBOutlet weak var isIdolizedButton: UIButton!
    
    @IBOutlet weak var isImportButton: UIButton!
    
    
    @IBAction func onKizunaMaxButtonDown(_ sender: UIButton) {
        self.isKizunaMax = !self.isKizunaMax
        if let handle = self.valueChangeHandle {
            handle((isImport: isImport, isIdolized: isIdolized, isKizunaMax: isKizunaMax, cell: self))
        }
    }
    
    
    @IBAction func onIdolizedButtonDown(_ sender: UIButton) {
        self.isIdolized = !self.isIdolized
        if let handle = self.valueChangeHandle {
            handle((isImport: isImport, isIdolized: isIdolized, isKizunaMax: isKizunaMax, cell: self))
        }
    }
    
    @IBAction func onImportButtonDown(_ sender: UIButton) {
        self.isImport = !self.isImport
        if let handle = self.valueChangeHandle {
            handle((isImport: isImport, isIdolized: isIdolized, isKizunaMax: isKizunaMax, cell: self))
        }
    }
    
    override func setupView(withCard: CardDataModel, userCard: UserCardDataModel) {
        
        super.setupView(withCard: withCard, userCard: userCard)
        self.isKizunaMax = userCard.isKizunaMax
        self.isImport = userCard.isImport
        self.isIdolized = userCard.isIdolized
        
    }
    
}

extension SIFCardImportCollectionViewCell {
    
}
