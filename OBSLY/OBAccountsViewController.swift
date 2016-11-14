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
    let accountCellIdentifier = "accountCellIdentifier"
    @IBOutlet weak var accountsListTableView: UITableView!
    var pulledAccounts: Array<Dictionary<String,AnyObject>> = [[String: AnyObject]]()
    
//MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        self.accountsListTableView.delegate = self
        self.accountsListTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAccountsList()
        self.tabBarController?.navigationItem.rightBarButtonItem = editButtonItem
    }
    
//MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pulledAccounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: accountCellIdentifier, for: indexPath) as! OBAccountTableViewCell
        let index = (indexPath as NSIndexPath).row
        let name = pulledAccounts[index]["name"]
        let sign = pulledAccounts[index]["sign"]
        let currency = pulledAccounts[index]["currency"]
        let startAmountFloat = pulledAccounts[index]["start_amt"]
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let startAmountString = formatter.string(from: startAmountFloat as! NSNumber)
        cell.accountNameLabel.text = name as! String?
        cell.accountSignLabel.text = sign as! String?
        cell.accountCurrencyLabel.text = currency as! String?
        cell.accountAmountLabel.text = startAmountString! as String

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
            let index = indexPath.row
            deleteAccount(index: index)
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
        self.accountsListTableView.setEditing(editing, animated: animated)
    }

//MARK: For segueing
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OBAddAccountViewController{
            let nextController = (segue.destination as! OBAddAccountViewController)
        }
    }
    
//MARK: Private methods
    
    @IBAction func addAccountAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: self.addAccountSegueIdentifier, sender: nil)
    }
    
    func deleteAccount(index: Int)    {
        let defaults = UserDefaults.standard
        var chosenBookKey = ""
        if let chosenBookKeyFromDefaults = defaults.string(forKey: "chosenBookKey") {
            chosenBookKey = chosenBookKeyFromDefaults
        }
        let accountIdToDelete = pulledAccounts[index]["_id"] as! String
        let urlPath: String = "http://obsly.com/api/v1/\(chosenBookKey)/accounts/\(accountIdToDelete)"
        let url: NSURL = NSURL(string: urlPath)!
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "DELETE"
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
                    
                    
//                    self.pulledAccounts = jsonArrayResponse as! Array<Dictionary<String, AnyObject>>
                    DispatchQueue.main.async{
//                        self.accountsListTableView.reloadData()
//                        activityIndicator.stopAnimating()
                        //                        blurView.removeFromSuperview()
                    }
                } catch let error as NSError {
                    self.presentErrorAlert(title: "Json parsing error", error: error)
                    print("json error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
        getAccountsList()
    }
    
    func getAccountsList()  {
//        let blurEffect = UIBlurEffect(style: .light)
//        var blurView: UIVisualEffectView!
//        blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = view.bounds
//        self.view.addSubview(blurView)
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
                    self.pulledAccounts = jsonArrayResponse as! Array<Dictionary<String, AnyObject>>
                    DispatchQueue.main.async{
                        self.accountsListTableView.reloadData()
                        activityIndicator.stopAnimating()
//                        blurView.removeFromSuperview()
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
//        self.automaticallyAdjustsScrollViewInsets = false // remove blank space above table view
        self.accountsListTableView.tableFooterView = UIView() // remove unused cell in table view
        self.accountsListTableView.allowsSelection = false
    }
}
