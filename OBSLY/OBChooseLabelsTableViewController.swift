//
//  OBChooseLabelsTableViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 11/6/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

class OBChooseLabelsTableViewController: UITableViewController {
    
    @IBOutlet var chooseLabelsTableView: UITableView!
    let chooseLabelCellIdentifier = "LabelsCell"
    var pulledLabels: Array<Dictionary<String,AnyObject>> = [[String: AnyObject]]()
    let OBCellButtonTag = 999
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getLabelsList()
        setupUI()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pulledLabels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: chooseLabelCellIdentifier, for: indexPath) as! OBLabelsTableViewCell

        

        // make separator line between cells to fill full width
        cell.separatorInset = UIEdgeInsetsMake(0, 0, cell.frame.size.width, 0)
        if (cell.responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins))){
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
        }
        
        let index = (indexPath as NSIndexPath).row
        let labelName = pulledLabels[index]["label"]
        let transactionsQuantityFloat = pulledLabels[index]["n"]
        
        let amounts = pulledLabels[index]["amt"]
    
        let UsdAmounts = amounts?["USD"] as AnyObject?
        
    
        let minusAmtFloat = UsdAmounts?["minus_amt"]
        let plusAmtFloat = UsdAmounts?["plus_amt"]
        
        let numbertFormatter = NumberFormatter()
        numbertFormatter.numberStyle = .decimal
        let transactionsQuantityString = numbertFormatter.string(from: transactionsQuantityFloat as! NSNumber)
        let minusAmtString = numbertFormatter.string(from: minusAmtFloat as! NSNumber)
        let plusAmtString = numbertFormatter.string(from: plusAmtFloat as! NSNumber)
        var currentUsdAmountString = ""
        if minusAmtString == "0" {
            currentUsdAmountString = plusAmtString!
        } else  {
            currentUsdAmountString = minusAmtString!
        }
        
        cell.labelNameLabel.text = labelName as! String?
        cell.labelNameLabel.text?.append(" (q-ty:\(transactionsQuantityString!); amt: \(currentUsdAmountString))")
        
        
        cell.selectionStyle = .none
        
        return cell
    }
    
//    override func tableviewselect
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.reloadRows(at: [indexPath], with: .fade)
        
        let cell = self.tableView.cellForRow(at: indexPath)
        let button = cell?.viewWithTag(OBCellButtonTag) as! UIButton
//        button.isSelected
        
        button.isSelected = (button.isSelected == true ? false : true)
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: chooseLabelCellIdentifier, for: indexPath) as! OBLabelsTableViewCell
//        
//        let index = (indexPath as NSIndexPath).row
//        let labelName = pulledLabels[index]["label"]
//        let transactionsQuantityFloat = pulledLabels[index]["n"]
//        let numbertFormatter = NumberFormatter()
//        numbertFormatter.numberStyle = .decimal
//        let transactionsQuantityString = numbertFormatter.string(from: transactionsQuantityFloat as! NSNumber)
//        
//        
//        
//        
//        cell.labelNameLabel.text = labelName as! String?
//        cell.labelNameLabel.text?.append(" (\(transactionsQuantityString!))")
        
//        let index = (indexPath as NSIndexPath).row
//        let cell = tableView.dequeueReusableCell(withIdentifier: chooseLabelCellIdentifier, for: indexPath) as! OBLabelsTableViewCell
//        if cell.isSelected  {
//            cell.setSelected(false, animated: true)
//            cell.checkImage.alpha = 0.0
//        }
//        else    {
//            cell.setSelected(true, animated: true)
//            cell.checkImage.alpha = 1.0
//        }
        
        
        
//        let accountName = pulledAccounts[index]["name"]
//        let accountID = pulledAccounts[index]["_id"]
//        let defaults = UserDefaults.standard
//        defaults.set(accountName, forKey: "chosenAccountName")
//        defaults.set(accountID, forKey: "chosenAccountID")
//        dismiss(animated: true, completion: nil)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Private methods
    
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
        let urlPath: String = "http://obsly.com/api/v1/\(chosenBookKey)/labels?load_amount=1&convertTo=USD"
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
                        self.chooseLabelsTableView.reloadData()
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
    
    //MARK: - Actions
    
    @IBAction func checkLabelAction(_ sender: UIButton) {
        sender.isSelected = (sender.isSelected == true ? false : true)
    }
    
    @IBAction func addLabelAction(_ sender: UIBarButtonItem) {
        let alert = UIAlertController.init(title: "Add new Label", message: "Enter the name of new label", preferredStyle: .alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        let addAction = UIAlertAction.init(title: "Add", style: .default, handler: { (_) in
            
            let newLabelName =  alert.textFields?[0].text
            let newLabelDict = ["label" : newLabelName!,
                                    "n" : 0,
                                  "amt" : ["USD" : ["minus_amt" : 0, "plus_amt" : 0]]
                               ] as [String : Any]
            self.pulledLabels.append(newLabelDict as [String : AnyObject])
            self.chooseLabelsTableView.reloadData()
            
        })
//        let labelTextField = alert.textFields![0] as UITextField
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        alert.addTextField(configurationHandler: { (textField) in
//            textField.placeholder = "Login"
//            
//            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { (notification) in
//                
//            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        let quantity = pulledLabels.count
        var labelsArray = [String]()
        for index in 0..<quantity   {
            let indexPath = IndexPath(row: index, section: 0)
            let cell = self.chooseLabelsTableView.cellForRow(at: indexPath)
            for view: UIView in cell!.contentView.subviews  {
                if view is UIButton {
                    let button = view as! UIButton
                    if button.isSelected  {
                        let labelName = pulledLabels[index]["label"]
                        labelsArray.append(labelName as! String)
                    }
                }
            }
        }
        
        
        let labelsString = labelsArray.joined(separator: ", ")
        let defaults = UserDefaults.standard
        defaults.set(labelsString, forKey: "chosenLabelsString")
        defaults.set(labelsArray, forKey: "chosenLabelsArray")
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - UI Stuff
    
    func setupUI()  {
        self.automaticallyAdjustsScrollViewInsets = false // remove blank space above table view
        self.chooseLabelsTableView.tableFooterView = UIView() // remove unused cell in table view
        self.chooseLabelsTableView.allowsSelection = true
        self.title = "Choose labels"
        self.navigationController?.navigationBar.isTranslucent = false
    }

}
