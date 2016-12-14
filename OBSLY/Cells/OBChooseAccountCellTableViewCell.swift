//
//  OBChooseAccountCellTableViewCell.swift
//  OBSLY
//
//  Created by Tung Fam on 10/13/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

/* ------------------------------------------ */
/* ACCOUNT CELL ON THE TABLE VIEW OF TRANSACTION CREATION */
/* ------------------------------------------ */

import UIKit

class OBChooseAccountCellTableViewCell: UITableViewCell {
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var chooseAccButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.fieldName.font = UIFont.applicationMediumFontOfSize(20)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
