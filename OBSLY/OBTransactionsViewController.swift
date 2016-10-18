//
//  OBTransactionsViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/21/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit
import CoreData

class OBTransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//MARK: init
    @IBOutlet weak var transactionsTableView: UITableView!
    let addTransactionSegueIdentifier = "addTransactionSegue"
    var pulledTransactions: Array<Dictionary<String,AnyObject>> = [[String: AnyObject]]()
    let showTransactionCellIdentifier = "showTransactionCell"
    
//MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        self.transactionsTableView.delegate = self
        self.transactionsTableView.dataSource = self

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTransactionsList()
    }

//MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pulledTransactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: showTransactionCellIdentifier, for: indexPath) as! OBShowTransactionTableViewCell
        let index = (indexPath as NSIndexPath).row
        let accountDict = pulledTransactions[index]["account"]
        let accountName = accountDict?["name"]
        let labelsNamesArray = (pulledTransactions[index]["label_list"] as? NSArray) as! Array<String>?
        let labelsNamesString = labelsNamesArray?.joined(separator: ", ")
        let currency = pulledTransactions[index]["currency"]
        let amountFloat = pulledTransactions[index]["amt"]
        let numbertFormatter = NumberFormatter()
        numbertFormatter.numberStyle = .decimal
        let amountString = numbertFormatter.string(from: amountFloat as! NSNumber)
        let dateString = pulledTransactions[index]["datetime_on"]
        let dataFormatterISO8601 = ISO8601DateFormatter()
        let date = dataFormatterISO8601.date(from: dateString as! String)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.none
        cell.dateLabel.text = dateFormatter.string(from: date!)
        
        cell.accountNameLabel.text =  accountName as! String?
        cell.labelsNamesLabel.text = labelsNamesString
        cell.amountLabel.text = amountString
        cell.currencyLabel.text = currency as! String?
        
        
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
        if editingStyle == .delete {
            // remove the deleted item from the сore date
//            let index = indexPath.row
//            deleteAccount(index: index)
        }
    }
    
    //for deleting (editing)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //for deleting (editing)
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
//        self.accountsListTableView.setEditing(editing, animated: animated)
    }

//MARK: For segueing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OBAccountsViewController{
            let nextController = (segue.destination as! OBAccountsViewController)

        }
        
    }
    
//MARK: Private methods
    
    func getTransactionsList()  {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        let defaults = UserDefaults.standard
        var chosenBookKey = ""
        if let chosenBookKeyFromDefaults = defaults.string(forKey: "chosenBookKey") {
            chosenBookKey = chosenBookKeyFromDefaults
        }
        let urlPath: String = "http://obsly.com/api/v1/\(chosenBookKey)/transactions"
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
            }
            else    {
                do {
                    // handle error
                    let jsonDictResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    print(jsonDictResponse)
                    if (jsonDictResponse?["error"]) != nil  { // if data contains error
                        DispatchQueue.main.async {
                            self.presentErrorAlertWithMessage(title: "Error", message: "Accounts not loaded: \(jsonDictResponse?["error"])")
                        }
                    } // handle error
                    
                    let jsonArrayResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSArray
                    print(jsonArrayResponse)
                    self.pulledTransactions = jsonArrayResponse as! Array<Dictionary<String, AnyObject>>
                    DispatchQueue.main.async{
                        self.transactionsTableView.reloadData()
                        activityIndicator.stopAnimating()
                    }
                } catch let error as NSError {
                    self.presentErrorAlert(title: "Json parsing error", error: error)
                    print("json error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
//MARK: UI stuff
    func setupUI()  {
        self.transactionsTableView.tableFooterView = UIView() // remove unused cell in table view
        self.tabBarController?.navigationItem.rightBarButtonItem = editButtonItem
        self.transactionsTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
//        self.transactionsTableView.contentInset = UIEdgeInsets.zero
//        self.automaticallyAdjustsScrollViewInsets = false // remove blank space above table view
//        self.transactionsTableView.allowsSelection = false
    }
    
//MARK: Actions
    @IBAction func addTransactionAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: addTransactionSegueIdentifier, sender: nil)
    }
    
    
}
