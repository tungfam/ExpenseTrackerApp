//
//  OBAccountsViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/25/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit
import CoreData

class OBAccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//MARK: init
    let addAccountSegueIdentifier = "addAccountSegue"
    var books = [NSManagedObject]()
    let accountCellIdentifier = "accountCellIdentifier"
    @IBOutlet weak var accountsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        accountsListTableView.delegate = self
        getAccountsList()
        // Do any additional setup after loading the view.
    }

    @IBAction func addAccountAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: self.addAccountSegueIdentifier, sender: nil)
    }
    
//MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: accountCellIdentifier, for: indexPath) as! OBAccountTableViewCell
        let index = (indexPath as NSIndexPath).row
        cell.accountNameLabel.text = "PrivatBank"
        cell.accountSignLabel.text = "$"
        cell.accountCurrencyLabel.text = "USD"
        cell.accountAmountLabel.text = "54343"
//        cell.titleLabel.text = "\(index + 1)."
//        let book = books[indexPath.row]
//        cell.valueLabel.text = book.value(forKey: "bookName") as! String?
        
        // make separator line between cells to fill full width
        cell.separatorInset = UIEdgeInsetsMake(0, 0, cell.frame.size.width, 0)
        if (cell.responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins))){
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        chosenIndexPath = indexPath.row
//        self.performSegue(withIdentifier: openBookSegueIdentifier, sender: nil)
    }
    
    // for deleting (editing)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // remove the deleted item from the сore date
//            
//            if #available(iOS 10.0, *) {
//                let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//                managedContext.delete(books[indexPath.row] as NSManagedObject)
//                books.remove(at: indexPath.row)
//                do {
//                    try managedContext.save()
//                } catch let error as NSError  {
//                    print("Could not save \(error), \(error.userInfo)")
//                }
//                // Delete the row from the data source
//                tableView.deleteRows(at: [indexPath], with: .fade)
//                // delay to reload the table
//                let when = DispatchTime.now() + 0.1
//                DispatchQueue.main.asyncAfter(deadline: when){
//                    self.booksListTableView.reloadData()
//                }
//            } else {
//                print("error: old iOS version")
//            }
//        }
    }
    
    // for deleting (editing)
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
    
    // for deleting (editing)
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        booksListTableView.setEditing(editing, animated: animated)
//    }

//MARK: For segueing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OBAddAccountViewController{
            let nextController = (segue.destination as! OBAddAccountViewController)
//            nextController.getChosenIndexOfBook(index: chosenBookIndex)
        }
    }
    
    internal func getChosenIndexOfBook(index: Int)  {
//        chosenBookIndex = index
//        print(chosenBookIndex)
//        
//        // getting books from coredata
//        if #available(iOS 10.0, *) {
//            let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//            let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
//            do {
//                let results =
//                    try managedContext.fetch(fetchRequest)
//                books = results
//            } catch let error as NSError {
//                print("Could not fetch \(error), \(error.userInfo)")
//            }
//        } else {
//            print("error: old iOS version")
//        }
//        
//        let book = books[index]
////        self.chosenBookKey = book.value(forKey: "bookKey") as! String
//        print("accounts vc")
//        print(book.value(forKey: "bookName") as! String?)
//        print(book.value(forKey: "bookKey") as! String?)
    }
    
//MARK: Private methods
    
    func getAccountsList()   {
        let defaults = UserDefaults.standard
        var chosenBookKey = ""
        if let chosenBookKeyFromDefaults = defaults.string(forKey: "chosenBookKey") {
            chosenBookKey = chosenBookKeyFromDefaults
        }
        let urlPath: String = "http://obsly.com/api/v1/\(chosenBookKey)/accounts"
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            print("Response: \(response)")
            print("Data: \(data)")
            print("Error: \(error)")
            if(error != nil) {
                print("Server Error: \(error!.localizedDescription)")
                DispatchQueue.main.async {
                    self.presentErrorAlert(title: "Error", error: error as! NSError)
                }
            } else    {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? NSDictionary
                    print(jsonResponse)
                    if (jsonResponse?["error"]) != nil  { // if data contains error
                        DispatchQueue.main.async {
                            self.presentErrorAlertWithMessage(title: "Error", message: "Accounts not loaded: \(jsonResponse?["error"])")
                        }
                    }
                    
                } catch let error as NSError {
                    self.presentErrorAlert(title: "Json parsing error", error: error)
                    print("json error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
//MARK: UI Stuff
    
    func setupUI()  {
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.applicationBoldFontOfSize(20)]
        self.automaticallyAdjustsScrollViewInsets = false // remove blank space above table view
        accountsListTableView.tableFooterView = UIView() // remove unused cell in table view
        
        
        
    }
}
