//
//  InputDataTableViewCell.swift
//  OBSLY
//
//  Created by Tung Fam on 9/9/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

class InputDataTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var fieldTitle: UILabel!
    @IBOutlet weak var fieldValue: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        fieldValue.delegate = self
        
        setupUI()
    }

    func setupUI()  {
        // make separator line between cells to fill full width
        self.separatorInset = UIEdgeInsetsMake(0, 0, self.frame.size.width, 0)
        if (self.responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins))){
            self.layoutMargins = UIEdgeInsets.zero
            self.preservesSuperviewLayoutMargins = false
        }
        
        self.fieldValue.autocapitalizationType = .sentences

        self.fieldTitle.font = UIFont.applicationMediumFontOfSize(20)
        self.fieldValue.font = UIFont.applicationRegularFontOfSize(20)
    }
    
    // add the space in the end of the text field when typing 'space'
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.fieldValue) {
            let oldString = textField.text!
            let newRange = oldString.characters.index(oldString.startIndex, offsetBy: range.location)..<oldString.characters.index(oldString.startIndex, offsetBy: range.location + range.length)
            let newString = oldString.replacingCharacters(in: newRange, with: string)
            textField.text = newString.replacingOccurrences(of: " ", with: "\u{00a0}");
            return false;
        } else {
            return true;
        }
    }

    // func that will dismiss keyboard on 'return' btn
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
