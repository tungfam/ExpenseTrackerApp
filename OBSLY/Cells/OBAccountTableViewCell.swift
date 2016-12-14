//
//  OBAccountTableViewCell.swift
//  OBSLY
//
//  Created by Tung Fam on 10/7/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

/* ------------------------------------------ */
/* TABLE VIEW WHERE USER CHOOSES ACCOUNT AMONG OTHER LABELS WHEN CREATING TRANSACTION */
/* ------------------------------------------ */

import UIKit

class OBAccountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var accountAmountLabel: UILabel!
    @IBOutlet weak var accountSignLabel: UILabel!
    @IBOutlet weak var accountCurrencyLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.accountNameLabel.font = UIFont.applicationMediumFontOfSize(20)
        self.accountAmountLabel.font = UIFont.applicationRegularFontOfSize(20)
        self.accountSignLabel.font = UIFont.applicationRegularFontOfSize(20)
        self.accountCurrencyLabel.font = UIFont.applicationRegularFontOfSize(12)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
