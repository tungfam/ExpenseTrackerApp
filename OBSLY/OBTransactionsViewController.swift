//
//  OBTransactionsViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/21/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

class OBTransactionsViewController: UIViewController {

    var chosenBookIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    internal func getChosenIndexOfBook(index: Int)  {
        chosenBookIndex = index
        print(chosenBookIndex)
    }
}
