//
//  OBLabelsViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/27/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit
import CoreData

class OBLabelsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//MARK: - init
    @IBOutlet weak var labelsTableView: UITableView!
    let labelCellIdentifier = "showLabelsCell"
    var pulledLabels: Array<Dictionary<String,AnyObject>> = [[String: AnyObject]]()
    
//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.labelsTableView.delegate = self
        self.labelsTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLabelsList()
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }

//MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pulledLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: labelCellIdentifier, for: indexPath) as! OBShowLabelsTableViewCell
        let index = (indexPath as NSIndexPath).row
        let labelName = pulledLabels[index]["label"]
        let transactionsQuantityFloat = pulledLabels[index]["n"]
        let numbertFormatter = NumberFormatter()
        numbertFormatter.numberStyle = .decimal
        let transactionsQuantityString = numbertFormatter.string(from: transactionsQuantityFloat as! NSNumber)
        
        cell.labelNameLabel.text = labelName as! String?
        cell.quantityLabel.text = transactionsQuantityString
        
        
        // make separator line between cells to fill full width
        cell.separatorInset = UIEdgeInsetsMake(0, 0, cell.frame.size.width, 0)
        if (cell.responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins))){
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
        }
        return cell
    }
    
//MARK: - Privae methods
    
    func getLabelsList()    {
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
        let urlPath: String = "http://obsly.com/api/v1/\(chosenBookKey)/labels"
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
                    self.pulledLabels = jsonArrayResponse as! Array<Dictionary<String, AnyObject>>
                    DispatchQueue.main.async{
                        self.labelsTableView.reloadData()
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
    
//MARK: UI stuff
    func setupUI()  {
//        self.automaticallyAdjustsScrollViewInsets = false // remove blank space above table view
        self.labelsTableView.tableFooterView = UIView() // remove unused cell in table view
        self.labelsTableView.allowsSelection = false
        self.labelsTableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0)
    }
}
