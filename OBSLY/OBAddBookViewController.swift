//
//  OBAddBookViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/9/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

class OBAddBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//MARK: init
    @IBOutlet weak var dataInputTableView: UITableView!
    
    let InputDataCellIdentifier = "InputDataCell"
    let InputDataTableViewCellIdentifier = "InputDataTableViewCell"
    let booksArrayKey = "BooksArray"
    var finalBookName: String = ""
    let defaults = NSUserDefaults.standardUserDefaults()
    
//MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        dataInputTableView.delegate = self
        dataInputTableView.dataSource = self
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        print("2nd vc \(defaults.dictionaryForKey(booksArrayKey))")
    }

//MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.registerNib(UINib(nibName: InputDataTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: InputDataCellIdentifier)
        let cell = tableView.dequeueReusableCellWithIdentifier(InputDataCellIdentifier, forIndexPath: indexPath) as! InputDataTableViewCell
        cell.fieldTitle.text = "Name"
        
        return cell
    }
    
//MARK: Private Methods
    @IBAction func saveAction(sender: UIBarButtonItem) {
        let index = NSIndexPath.init(forItem: 0, inSection: 0)
        
        let bookNameCell = self.dataInputTableView.cellForRowAtIndexPath(index)
        
        for view: UIView in bookNameCell!.contentView.subviews {
            if (view is UITextField) {
                let bookNameField = (view as! UITextField)
                var oldBooksDict = self.defaults.dictionaryForKey(self.booksArrayKey)
                let counter = self.defaults.integerForKey("counter")
                self.defaults.setInteger(counter + 1, forKey: "counter")
                if oldBooksDict == nil  {
                    let bookDict: [String: String] = [bookNameField.text!: "\(self.defaults.integerForKey("counter"))"]
                    self.defaults.setObject(bookDict, forKey: self.booksArrayKey)
                } else  {
                    oldBooksDict?[bookNameField.text!] = "\(self.defaults.integerForKey("counter"))"
                    let newBooksDict = oldBooksDict
                    self.defaults.setObject(newBooksDict, forKey: self.booksArrayKey)
                    print("2nd vc \(self.defaults.dictionaryForKey(self.booksArrayKey))")
                }
                
//                let newBook: [String: String] = ["\(bookNameField.text)": "test book key value"]
                
//                self.defaults.setObject(bookDict, forKey: self.booksArrayKey)
                print("2nd vc \(self.defaults.dictionaryForKey(self.booksArrayKey))")
            }
        }
//        self.dataInputTableView.registerNib(UINib(nibName: InputDataTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: InputDataCellIdentifier)
        //            let bookNameCell = self.tableView(self.dataInputTableView, cellForRowAtIndexPath: index)
//        let bookNameCell = self.dataInputTableView.dequeueReusableCellWithIdentifier(self.InputDataCellIdentifier, forIndexPath: index) as! InputDataTableViewCell
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    @IBAction func cancelAction(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupUI()  {
        self.title = "New Book"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.applicationBoldFontOfSize(20)]
        self.automaticallyAdjustsScrollViewInsets = false // remove blank space above table view
        dataInputTableView.tableFooterView = UIView() // remove unused cell in table view

    }

}
