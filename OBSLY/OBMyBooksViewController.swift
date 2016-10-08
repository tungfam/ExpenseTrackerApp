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
    let openBookSegueIdentifier = "openBookSegue"
    let bookCellIdentifier = "ShowDataTableViewCell"
    
    var chosenIndexPath = 0
    var books = [NSManagedObject]()
    
//MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        booksListTableView.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 10.0, *) {
            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
            do {
                let results =
                    try managedContext.fetch(fetchRequest)
                books = results
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            booksListTableView.reloadData()
        } else {
            print("error: old iOS version")
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenIndexPath = indexPath.row
        self.performSegue(withIdentifier: openBookSegueIdentifier, sender: nil)
    }

    // for deleting (editing)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // remove the deleted item from the сore date
            
            if #available(iOS 10.0, *) {
                let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                managedContext.delete(books[indexPath.row] as NSManagedObject)
                books.remove(at: indexPath.row)
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)
                // delay to reload the table
                let when = DispatchTime.now() + 0.1
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.booksListTableView.reloadData()
                }
            } else {
                print("error: old iOS version")
            }
        }
    }
    
    // for deleting (editing)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // for deleting (editing)
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        booksListTableView.setEditing(editing, animated: animated)
    }

//MARK: Private Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OBTabBarViewController{
            let nextController = (segue.destination as! OBTabBarViewController)
            nextController.getChosenIndexOfBook(index: chosenIndexPath)
        }

    }
    
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
    
    func reloadTableView(timer: Timer)  {
        booksListTableView.reloadData()
    }
    
}
