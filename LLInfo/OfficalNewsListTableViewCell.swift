//
//  OfficalNewsListTableViewCell.swift
//  LLInfo
//
//  Created by CmST0us on 2018/1/5.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class OfficalNewsListTableViewCell: UITableViewCell {
    @IBOutlet weak var briefImageImageView: UIImageView?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    struct CellId {
        static let officalNewsCellNormalId = "offical_news_cell_normal_id"
        static let officalNewsCellNoImageId = "offical_news_cell_no_image_id"
    }
    
    override func layoutSubviews() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.3
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        
    }
    
    func setupCell(withInfoDataModel model: OfficalNewsDataModel)  {
        self.titleLabel.text = model.title
        self.timeLabel.text = model.formatTime
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
