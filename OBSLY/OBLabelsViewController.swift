//
//  OBLabelsViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/27/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit
import CoreData

class OBLabelsViewController: UIViewController {

//MARK: init
    var books = [NSManagedObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }

//MARK: UI stuff
    func setupUI()  {
        self.tabBarController?.navigationItem.rightBarButtonItem = editButtonItem
    }
}
