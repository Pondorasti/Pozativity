//
//  ContractTableViewCell.swift
//  Pozativity
//
//  Created by Alexandru Turcanu on 22/09/2018.
//  Copyright © 2018 Alexandru Turcanu. All rights reserved.
//

import UIKit

class ContractTableViewCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contractorLabel: UILabel!
    
    @IBOutlet weak var deadlineTitleLabel: UILabel!
    @IBOutlet weak var deadlineDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        layer.masksToBounds = false
        
        titleLabel.textColor = .mgTitle
        contractorLabel.textColor = .mgSubtitle
        
        deadlineDateLabel.textColor = .mgVodafone
        deadlineTitleLabel.textColor = .mgVodafone
        
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
