//
//  InfoTableViewCell.swift
//  LLInfo
//
//  Created by CmST0us on 2017/11/17.
//  Copyright © 2017年 eki. All rights reserved.
//

import UIKit

class InfoListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var sourceIcon: UIImageView!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var briefLabel: UILabel!
    @IBOutlet weak var briefImageImageView: UIImageView!
    
    struct CellId {
        static let infoListCellId = "info_list_cell_id"
    }
    
    
    private func sourceStringWithIcon(source: String?) -> UIImage? {
        if source == nil {
            return nil
        }
        let iconName = source! + "_icon"
        if let iconImage = UIImage(named: iconName) {
            return iconImage
        }
        return nil
        
    }
    
    func setupCell(withInfoDataModel model: InfoDataModel)  {
        self.timeLabel.text = model.formatTime
        self.sourceNameLabel.text = model.sourceName
        self.sourceIcon.image = sourceStringWithIcon(source: model.source)
        if let t = model.tags {
            self.tagsLabel.text = t.joined(separator: "  ")
        }
        self.titleLabel.text = model.title?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.briefLabel.text = model.brief
    }
        
}

// MARK: - View Life cycle method
extension InfoListTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    override func prepareForReuse() {
        self.backgroundColor = UIColor.white
        self.briefImageImageView.image = UIImage(named: "image_placehold")
        
    }
}
