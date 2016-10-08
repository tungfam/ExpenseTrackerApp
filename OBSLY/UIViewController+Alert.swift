//
//  UIViewController+Alert.swift
//  OBSLY
//
//  Created by Tung Fam on 10/7/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentErrorAlert(title: String, error: NSError) {
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        let okButtonOnAlertAction = UIAlertAction(title: "OK", style: .default)
        { (action) -> Void in
            // nil
        }
        alert.addAction(okButtonOnAlertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func presentErrorAlertWithMessage(title: String, message: String)   {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButtonOnAlertAction = UIAlertAction(title: "OK", style: .default)
        { (action) -> Void in
            // nil
        }
        alert.addAction(okButtonOnAlertAction)
        present(alert, animated: true, completion: nil)
    }
}
