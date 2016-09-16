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
        if (self.respondsToSelector(Selector("preservesSuperviewLayoutMargins"))){
            self.layoutMargins = UIEdgeInsetsZero
            self.preservesSuperviewLayoutMargins = false
        }
        
        self.fieldValue.autocapitalizationType = .Sentences

        self.fieldTitle.font = UIFont.applicationMediumFontOfSize(20)
        self.fieldValue.font = UIFont.applicationRegularFontOfSize(20)
    }
    
    // add the space in the end of the text field when typing 'space'
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == self.fieldValue) {
            let oldString = textField.text!
            let newRange = oldString.startIndex.advancedBy(range.location)..<oldString.startIndex.advancedBy(range.location + range.length)
            let newString = oldString.stringByReplacingCharactersInRange(newRange, withString: string)
            textField.text = newString.stringByReplacingOccurrencesOfString(" ", withString: "\u{00a0}");
            return false;
        } else {
            return true;
        }
    }

    // func that will dismiss keyboard on 'return' btn
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
