//
//  OldContractsTableViewCell.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 23/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import UIKit

class OldContractsTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contractorLabel: UILabel!
    
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var tagView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        layer.masksToBounds = false
        
        titleLabel.textColor = .mgTitle
        contractorLabel.textColor = .mgSubtitle
        
        tagLabel.textColor = .mgWhite
        tagView.layer.cornerRadius = Constants.cornerRadius - 4
        
        contentView.backgroundColor = UIColor.mgGray
        containerView.backgroundColor = UIColor.mgWhite
        
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.layer.setUpShadow()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
