//
//  MyCollectionViewCell.swift
//  LLInfo
//
//  Created by CmST0us on 2017/11/15.
//  Copyright © 2017年 eki. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var infoSourceBriefImage: UIImageView!
    @IBOutlet weak var infoSourceLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleContextBriefLabel: UILabel!
    @IBOutlet weak var articleTimeLabel: UILabel!
    
    @IBOutlet weak var articleThumbnailImage1: UIImageView!
    @IBOutlet weak var articleThumbnailImage2: UIImageView!
    @IBOutlet weak var articleThumbnailImage3: UIImageView!
    @IBOutlet weak var articleThumbnailImage4: UIImageView!
    
    override func draw(_ rect: CGRect) {
        self.layer.borderColor = UIColor(white: 0.8, alpha: 1).cgColor
        self.layer.borderWidth = 0.5
        self.contentView.backgroundColor = UIColor.white
    }
    
    override func prepareForReuse() {
        self.backgroundColor = UIColor.white
        self.articleThumbnailImage1.image = nil
        self.articleThumbnailImage1.backgroundColor = UIColor.gray
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
    private func convertTimerIntervalToFormatString(timeInterval: TimeInterval) -> String {
        let time = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm"
        let timezone = TimeZone(secondsFromGMT: 7)
        formatter.timeZone = timezone
        let timeString = formatter.string(from: time)
        return timeString
    }
    func setupCellWithInfoData(_ infoData: MyInfoDataModel)  {
        self.infoSourceLabel.text = infoData.source
        self.articleTitleLabel.text = infoData.title
        self.articleContextBriefLabel.text = infoData.tags.joined(separator: ", ")
        
        if infoData.briefImage == nil {
            DispatchQueue.global().async {
                infoData.fetchImage()
                DispatchQueue.main.async {
                    self.articleThumbnailImage1.image = infoData.briefImage
                }
            }
        } else {
            self.articleThumbnailImage1.image = infoData.briefImage
        }
        
        
        self.articleTimeLabel.text = self.convertTimerIntervalToFormatString(timeInterval: TimeInterval(infoData.time))
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        super.preferredLayoutAttributesFitting(layoutAttributes)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        let size = self.systemLayoutSizeFitting(layoutAttributes.size)
        var cellFrame = layoutAttributes.frame;
        
        cellFrame.size.height = size.height;
        layoutAttributes.frame = cellFrame;
        
        return layoutAttributes;
    }
}
