//
//  OBMyBooksViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/7/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit
import CoreData

class OBMyBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//MARK: init
    @IBOutlet weak var booksListTableView: UITableView!
    
    let addBookManuallySegueIdentifier = "addBookManuallySegue"
    let bookCellIdentifier = "ShowDataTableViewCell"
    
    var books = [NSManagedObject]()
    
//MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(OBMyBooksViewController.updateBooksTable), name: "updateBooksTable", object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let managedContext = DataController().managedObjectContext
        
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            books = results
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        booksListTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "updateBooksTable"), object: nil)
    }
    
//MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: bookCellIdentifier, for: indexPath) as! ShowDataTableViewCell
        let index = (indexPath as NSIndexPath).row
        cell.titleLabel.text = "\(index + 1)."
        
        let book = books[indexPath.row]
        
        cell.valueLabel.text = book.value(forKey: "bookName") as! String?
        
        
        // make separator line between cells to fill full width
        cell.separatorInset = UIEdgeInsetsMake(0, 0, cell.frame.size.width, 0)
        if (cell.responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins))){
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
        }
        
        return cell
        
    }

//MARK: Private Methods
    @IBAction func showAddBookAlert(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Choose how to create a new Book", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let createBookManuallyAction = UIAlertAction(title: "Manually", style: .default, handler: {
            action in
            self.performSegue(withIdentifier: self.addBookManuallySegueIdentifier, sender: nil)
            }
        )
        alertController.addAction(createBookManuallyAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
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
