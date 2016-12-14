//
//  OBLabelsTableViewCell.swift
//  OBSLY
//
//  Created by Tung Fam on 11/6/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

/* ------------------------------------------ */
/* TABLE VIEW WHERE USER CHOOSES LABELS AMONG OTHER LABELS WHEN CREATING TRANSACTION */
/* ------------------------------------------ */

import UIKit

class OBLabelsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelNameLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.labelNameLabel.font = UIFont.applicationMediumFontOfSize(20)
        
        
        let image = UIImage(named: "check")?.withRenderingMode(.alwaysTemplate)
        self.checkButton.setImage(image, for: .selected)
        self.checkButton.tintColor = UIColor.init(red: 255.0/255, green: 74.0/255, blue: 118.0/255, alpha: 1.0)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
