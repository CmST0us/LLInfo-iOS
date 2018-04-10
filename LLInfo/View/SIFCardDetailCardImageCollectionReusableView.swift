//
//  SIFCardDetailCardImageCollectionReusableView.swift
//  LLInfo
//
//  Created by CmST0us on 2018/4/3.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit
import SDWebImage

class SIFCardDetailCardImageCollectionReusableView: UICollectionReusableView {
    
    enum CardImageType: Int {
        case normal = 0
        case clear = 1
        case transparent = 2
    }
    
    var cardImageType: CardImageType {
        return CardImageType(rawValue: self.cardImageStyleSegmentedControl.selectedSegmentIndex) ?? .normal
    }
    
    var cardImageViewUrlBlock: ((_ idolized: Bool, _ cardImageType: CardImageType) -> String?)? = nil
    
    func setupView(withUserCard userCard: UserCardDataModel, cardDataModel: CardDataModel) {
        switch cardDataModel.attribute {
        case CardDataModel.Attribute.cool:
            self.cardImageStyleSegmentedControl.tintColor = UIColor.coolAttribute
        case CardDataModel.Attribute.smile:
            self.cardImageStyleSegmentedControl.tintColor = UIColor.smileAttribute
        case CardDataModel.Attribute.pure:
            self.cardImageStyleSegmentedControl.tintColor = UIColor.pureAttribute
        case CardDataModel.Attribute.all:
            self.cardImageStyleSegmentedControl.tintColor = UIColor.allAttribute
        default:
            self.cardImageStyleSegmentedControl.tintColor = UIColor.aqua
        }
    }
    // MARK: IBOutlet IBAction
    @IBOutlet weak var idolizedImageView: TapToZoomImageView!
    @IBOutlet weak var nonIdolizedImageView: TapToZoomImageView!
    @IBOutlet weak var cardImageStyleSegmentedControl: UISegmentedControl!
    
    @IBAction func onCardImageStyleChange(_ sender: UISegmentedControl) {
        reloadData()
    }

    override func layoutSubviews() {
        reloadData()
    }
    // MARK: Private Method
    private func reloadData() {
        if let block = self.cardImageViewUrlBlock {
            let idolizedPath = block(true, cardImageType) ?? ""
            let nonidolizedPath = block(false, cardImageType) ?? ""
            self.idolizedImageView.isHidden = false
            self.nonIdolizedImageView.isHidden = false
            
            if let idolizedUrl = URL(string: idolizedPath) {
                self.idolizedImageView.sd_setImage(with: idolizedUrl, placeholderImage: #imageLiteral(resourceName: "sif_card_placeholder"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: { (image, error, type, url) in
                    self.idolizedImageView.image = image
                })
            } else {
                self.idolizedImageView.isHidden = true
            }
            
            if let nonidolizedUrl = URL(string: nonidolizedPath) {
                self.nonIdolizedImageView.sd_setImage(with: nonidolizedUrl, placeholderImage: #imageLiteral(resourceName: "sif_card_placeholder"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: { (image, error, typr, url) in
                    self.nonIdolizedImageView.image = image
                })
            } else {
                self.nonIdolizedImageView.isHidden = true
            }
            
        }
    }
    
}
