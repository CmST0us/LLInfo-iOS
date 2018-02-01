//
//  DetailTableViewCell.swift
//  testHostApp
//
//  Created by CmST0us on 2018/1/8.
//  Copyright © 2018年 eki. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var keyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell(withKey key:String?, value: String?) {
        self.valueTextField.text = value
        self.keyLabel.text = key
    }
}
