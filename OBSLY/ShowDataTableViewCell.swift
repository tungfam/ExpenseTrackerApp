//
//  ShowDataTableViewCell.swift
//  OBSLY
//
//  Created by Tung Fam on 9/11/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

class ShowDataTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.font = UIFont.applicationMediumFontOfSize(20)
        self.valueLabel.font = UIFont.applicationRegularFontOfSize(20)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
