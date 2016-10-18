//
//  OBShowTransactionTableViewCell.swift
//  OBSLY
//
//  Created by Tung Fam on 10/14/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

class OBShowTransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var labelsNamesLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI()  {
        self.accountNameLabel.font = UIFont.applicationMediumFontOfSize(18)
        self.labelsNamesLabel.font = UIFont.applicationMediumFontOfSize(12)
        self.labelsNamesLabel.textColor = UIColor.gray
        self.amountLabel.font = UIFont.applicationRegularFontOfSize(18)
        self.currencyLabel.font = UIFont.applicationRegularFontOfSize(12)
        self.currencyLabel.textColor = UIColor.gray
        self.dateLabel.font = UIFont.applicationRegularFontOfSize(12)
        self.dateLabel.textColor = UIColor.gray
    }

}
