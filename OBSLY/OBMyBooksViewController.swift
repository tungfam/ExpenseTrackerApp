//
//  OBMyBooksViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/7/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

class OBMyBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//MARK: init
    @IBOutlet weak var booksListTableView: UITableView!
    
    let addBookManuallySegueIdentifier = "addBookManuallySegue"
    let booksDictKey = "BooksArray"
    let defaults = NSUserDefaults.standardUserDefaults()
    let bookCellIdentifier = "ShowDataTableViewCell"
    
    
//MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OBMyBooksViewController.updateBooksTable), name: "updateBooksTable", object: nil)
        
    }
    override func viewWillAppear(animated: Bool) {
        print("1st vc \(defaults.dictionaryForKey(booksDictKey))")
        booksListTableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "updateBooksTable", object: nil)
    }
    
//MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (defaults.dictionaryForKey(booksDictKey)?.count) != nil  {
            return (defaults.dictionaryForKey(booksDictKey)?.count)!
        }
        else {return 0}
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(bookCellIdentifier, forIndexPath: indexPath) as! ShowDataTableViewCell
        let index = indexPath.row
        cell.titleLabel.text = "\(index + 1)."
        if let booksDict: Dictionary = defaults.dictionaryForKey(booksDictKey)    {
            let keysArray = Array(booksDict.keys)
            cell.valueLabel.text = keysArray[index]
            
        }
        
        // make separator line between cells to fill full width
        cell.separatorInset = UIEdgeInsetsMake(0, 0, cell.frame.size.width, 0)
        if (cell.respondsToSelector(Selector("preservesSuperviewLayoutMargins"))){
            cell.layoutMargins = UIEdgeInsetsZero
            cell.preservesSuperviewLayoutMargins = false
        }
        
        return cell
        
    }

//MARK: Private Methods
    @IBAction func showAddBookAlert(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Choose how to create a new Book", message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        let createBookManuallyAction = UIAlertAction(title: "Manually", style: .Default, handler: {
            action in
            self.performSegueWithIdentifier(self.addBookManuallySegueIdentifier, sender: nil)
            }
        )
        alertController.addAction(createBookManuallyAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setupUI()  {
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.applicationBoldFontOfSize(20)]
        self.automaticallyAdjustsScrollViewInsets = false // remove blank space above table view
        booksListTableView.tableFooterView = UIView() // remove unused cell in table view
        
        

    }
    
//    func updateBooksTable() {
//    
//    }
    
    
}
