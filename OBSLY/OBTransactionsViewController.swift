//
//  OBTransactionsViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/21/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit
import CoreData

class OBTransactionsViewController: UIViewController {

//MARK: init
    let addTransactionSegueIdentifier = "addTransactionSegue"
    var chosenBookIndex = 0
    var books = [NSManagedObject]()
    
//MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

//MARK: For segueing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OBAccountsViewController{
            let nextController = (segue.destination as! OBAccountsViewController)

        }
        
    }
    
//MARK: Private methods
    
    
//MARK: UI stuff
    func setupUI()  {
        self.tabBarController?.navigationItem.rightBarButtonItem = editButtonItem
    }
    
//MARK: Actions
    @IBAction func addTransactionAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: addTransactionSegueIdentifier, sender: nil)
    }
    
    
}
