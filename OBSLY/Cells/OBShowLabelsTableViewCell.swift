//
//  OBShowLabelsTableViewCell.swift
//  OBSLY
//
//  Created by Tung Fam on 10/16/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

class OBShowLabelsTableViewCell: UITableViewCell {
    @IBOutlet weak var labelNameLabel: UILabel!
    @IBOutlet weak var transactionsPlaceholderLabel: UILabel!
    @IBOutlet weak var currentUsdAmount: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI()  {
        self.labelNameLabel.font = UIFont.applicationRegularFontOfSize(20)
        self.quantityLabel.font = UIFont.applicationRegularFontOfSize(16)
        self.transactionsPlaceholderLabel.font = UIFont.applicationRegularFontOfSize(10)
        self.transactionsPlaceholderLabel.textColor = UIColor.gray
    }

}
