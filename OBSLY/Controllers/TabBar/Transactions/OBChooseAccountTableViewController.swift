//
//  OBChooseAccountTableViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 10/13/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

class OBChooseAccountTableViewController: UITableViewController {

    @IBOutlet var chooseAccTableView: UITableView!
    let chooseAccountCellIdentifier = "chooseAccountCell"
    var pulledAccounts: Array<Dictionary<String,AnyObject>> = [[String: AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAccountsList()
        setupUI()
//        self.chooseAccTableView.delegate = self
//        self.chooseAccTableView.dataSource = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }

    

// MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pulledAccounts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chooseAccountCellIdentifier, for: indexPath) as! OBAccountTableViewCell
        let index = (indexPath as NSIndexPath).row
        let name = pulledAccounts[index]["name"]
        let sign = pulledAccounts[index]["sign"]
        let currency = pulledAccounts[index]["currency"]
        let currentAmountFloat = pulledAccounts[index]["amt_converted"]
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let currentAmountString = formatter.string(from: currentAmountFloat as! NSNumber)
        cell.accountNameLabel.text = name as! String?
        cell.accountSignLabel.text = sign as! String?
        cell.accountCurrencyLabel.text = currency as! String?
        cell.accountAmountLabel.text = currentAmountString! as String
        
        // make separator line between cells to fill full width
        cell.separatorInset = UIEdgeInsetsMake(0, 0, cell.frame.size.width, 0)
        if (cell.responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins))){
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
        }
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = (indexPath as NSIndexPath).row
        let accountName = pulledAccounts[index]["name"]
        let accountID = pulledAccounts[index]["_id"]
        let accountCurrency = pulledAccounts[index]["currency"]
        let defaults = UserDefaults.standard
        defaults.set(accountName, forKey: "chosenAccountName")
        defaults.set(accountID, forKey: "chosenAccountID")
        defaults.set(accountCurrency, forKey: "chosenAccountCurrency")
        dismiss(animated: true, completion: nil)
    }
    
//MARK: - Segue
    
//    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        if (segue.identifier == "Load View") {
//            // pass data to next view
//        }
//    }
    
//MARK: - Private methods
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func getAccountsList()  {
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
        let urlPath: String = "http://obsly.com/api/v1/\(chosenBookKey)/accounts?load_amount=1"
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
                        self.chooseAccTableView.reloadData()
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
    
    func setupUI()  {
        self.automaticallyAdjustsScrollViewInsets = false // remove blank space above table view
        self.chooseAccTableView.tableFooterView = UIView() // remove unused cell in table view
        self.chooseAccTableView.allowsSelection = true
        self.title = "Choose account"
        self.navigationController?.navigationBar.isTranslucent = false
    }

}
