//
//  OBAddTransactionViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 10/10/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

enum OBTableRow: Int   {
    case amount = 0
    case account = 1
    case labels = 2
    case date = 3
    case currency = 4
    case rate = 5
    case note = 6
}

enum OBPickerType   {
    case datePicker
    case currencyPicker
}

class OBAddTransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
//MARK: init
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var transactionsTableView: UITableView!
    let chooseAccSegueIdentifier = "chooseAccountSegue"
    let chooseLabelsSegueIdentifier = "chooseLabelsSegue"
    let InputDataCellIdentifier = "InputDataCell" // cell's identifier
    let accountCellIdentifier = "accountCell"
    let chooseLabelsCellIdentifier = "chooseLabelsCell"
    let InputDataTableViewCellIdentifier = "InputDataTableViewCell" // class name of cell
    let inputSections = 1
    let inputFieldsArray = ["Amount*", "Account*", "Labels*", "Date", "Currency", "Rate", "Note"]
    let currencyArray = ["USD", "UAH", "EUR"]
    let array = ["asdf", "asdf", "EUR"]
    var datePickerView = UIDatePicker()
    var currencyPickerView = UIPickerView()
    var selectedCurrency = ""
    let currencyRowIndexPath = IndexPath.init(row: 4, section: 0)
    let dateRowIndexPath = IndexPath.init(row: 3, section: 0)
    let defaults = UserDefaults.standard
    let paramsForPostTransaction = ["amt", "account_id", "label_list", "datetime_on", "currency", "rate", "note", "key"]
    var dictWithTransactionData = [String: AnyObject]()

//MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.transactionsTableView.delegate = self
        self.transactionsTableView.dataSource = self
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        
        // we set empty chosen account so that when user chooses the account we show chosen data
        defaults.set("Choose account", forKey: "chosenAccountName")
        defaults.set(nil, forKey: "chosenAccountID")
        defaults.set("Choose labels", forKey: "chosenLabelsString")
        defaults.set(nil, forKey: "chosenLabelsArray")
//        let testLabelsArray: [String] = ["test_label_1", "test_label_2", "test_label_3"]
//        let testLabelsArray: [String] = ["test_label_1"]
//        defaults.setValue(testLabelsArray, forKey: "chosenLabelsArray")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.transactionsTableView.reloadData()
    }

//MARK: Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return inputSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputFieldsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let cellID = OBTableRow(rawValue: indexPath.row)   {
            if cellID == .account   {
                let accountCell = tableView.dequeueReusableCell(withIdentifier: accountCellIdentifier, for: indexPath) as! OBChooseAccountCellTableViewCell
                let accountName = defaults.string(forKey: "chosenAccountName")
                print(defaults.string(forKey: "chosenAccountID"))
                accountCell.chooseAccButton.setTitle(accountName, for: .normal)
//                accountCell.chooseAccButton.setTitle("Choose account", for: .normal)
                cell = accountCell
            } else if cellID == .labels {
                let labelsCell = tableView.dequeueReusableCell(withIdentifier: chooseLabelsCellIdentifier, for: indexPath) as! OBChooseLabelsCell
                let labelsString = defaults.value(forKey: "chosenLabelsString") as! String
                labelsCell.chooseLabelButton.setTitle(labelsString, for: .normal)
                
                cell = labelsCell
            } else  {
                tableView.register(UINib(nibName: InputDataTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: InputDataCellIdentifier)
                let nibCell = tableView.dequeueReusableCell(withIdentifier: InputDataCellIdentifier, for: indexPath) as! InputDataTableViewCell
                
                switch cellID {
                case .amount:
                    nibCell.fieldValue.keyboardType = UIKeyboardType.decimalPad
                    break
                case .date: // date
                    let toolBar = self.returnToolBar(forPicker: .datePicker)
                    nibCell.fieldValue.inputAccessoryView = toolBar
                    nibCell.fieldValue.inputView = datePickerView
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = DateFormatter.Style.short
                    dateFormatter.timeStyle = DateFormatter.Style.short
                    nibCell.fieldValue.text = dateFormatter.string(from: self.datePickerView.date)
                    break
                case .currency: // currency
                    let toolBar = self.returnToolBar(forPicker: .currencyPicker)
                    nibCell.fieldValue.inputAccessoryView = toolBar
                    nibCell.fieldValue.inputView = currencyPickerView
                    nibCell.fieldValue.text = selectedCurrency
                    break
                case .rate:
                    nibCell.fieldValue.keyboardType = UIKeyboardType.decimalPad
                    break
                default:
                    break
                }
                nibCell.fieldTitle.text = inputFieldsArray[indexPath.row]
                
                cell = nibCell
            }
        }
        
        return cell
    }
    
//MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int  {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int   {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == currencyPickerView {
            return currencyArray[row]
        }
        else    {
            return array[row]
        }
    }

    
//MARK: Private methods
    func returnToolBar(forPicker: OBPickerType) -> UIToolbar  {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: nil)
        if forPicker == .currencyPicker {
            doneButton.action = #selector(OBAddTransactionViewController.reloadCurrencyTextFieldRow)
        } else  {
            doneButton.action = #selector(OBAddTransactionViewController.reloadDateTextFieldRow)
        }
        
        doneButton.tintColor = UIColor(red: 255/255, green: 74/255, blue: 118/255, alpha: 1)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    func reloadCurrencyTextFieldRow()   {
        let cell = transactionsTableView.dequeueReusableCell(withIdentifier: InputDataCellIdentifier, for: currencyRowIndexPath) as! InputDataTableViewCell
        cell.fieldValue.resignFirstResponder()
        transactionsTableView.reloadRows(at: [currencyRowIndexPath], with: .automatic)
    }
    
    func reloadDateTextFieldRow()  {
        let cell = transactionsTableView.dequeueReusableCell(withIdentifier: InputDataCellIdentifier, for: currencyRowIndexPath) as! InputDataTableViewCell
        cell.fieldValue.resignFirstResponder()
        transactionsTableView.reloadRows(at: [dateRowIndexPath], with: .automatic)
    }
    
    func postTransaction()   {
        var chosenBookKey = ""
        if let chosenBookKeyFromDefaults = defaults.string(forKey: "chosenBookKey") {
            chosenBookKey = chosenBookKeyFromDefaults
        }
        let keyParamInDict = paramsForPostTransaction[7] // adding book key to the dictionary
        dictWithTransactionData[keyParamInDict] = chosenBookKey as AnyObject?
        print(dictWithTransactionData)
        
        let url = NSURL(string: "http://obsly.com/api/v1/\(chosenBookKey)/transactions")
        print(url)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST" //set http method as POST
        do {
            let body = try JSONSerialization.data(withJSONObject: dictWithTransactionData, options: JSONSerialization.WritingOptions.prettyPrinted)  // pass dictionary to nsdata object and set it as request body
            request.httpBody = body
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
            self.presentErrorAlert(title: "Error", error: error)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
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
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    print(jsonResponse)
                    if (jsonResponse?["error"]) != nil  { // if data contains error
                        DispatchQueue.main.async {
                            self.presentErrorAlertWithMessage(title: "Error", message: "Account not saved: \(jsonResponse?["error"])")
                        }
                    } else    {
                        self.dismiss(animated: true, completion: nil) // leaving addTransaction VC
                    }
                } catch let error as NSError {
                    self.presentErrorAlert(title: "Error", error: error)
                    print("json error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }

    
//MARK: - Actions
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        if showAlertOfWrongFormat() {
            for i in (0..<inputFieldsArray.count)    {
                let index = IndexPath.init(item: i, section: 0)
                
                if i == OBTableRow.account.rawValue    {
                    let accountID = defaults.string(forKey: "chosenAccountID")
                    let paramNameInDict = paramsForPostTransaction[i]
                    dictWithTransactionData[paramNameInDict] = accountID as AnyObject?
                }
                else if i == OBTableRow.labels.rawValue {
                    let labelsArray = defaults.array(forKey: "chosenLabelsArray")
                    let paramNameInDict = paramsForPostTransaction[i]
                    let finalArray = NSMutableArray()
                    finalArray.addObjects(from: labelsArray!)
                    print(labelsArray)
                    dictWithTransactionData[paramNameInDict] = finalArray as AnyObject?
                    print(dictWithTransactionData)
                }
                
                let cell = self.transactionsTableView.cellForRow(at: index)
                for view: UIView in cell!.contentView.subviews {
                    if (view is UITextField) {
                        let inputField = (view as! UITextField)
                        // adding value to dictionary
                        if i == OBTableRow.amount.rawValue || i == OBTableRow.rate.rawValue    {
                            let numberValue : Float = NSString(string: inputField.text!).floatValue
                            let paramNameInDict = paramsForPostTransaction[i]
                            dictWithTransactionData[paramNameInDict] = numberValue as AnyObject?
                        }
                        else if i == OBTableRow.date.rawValue   {
                            let paramNameInDict = paramsForPostTransaction[i]
                            let date = self.datePickerView.date
                            let formatter = ISO8601DateFormatter()
//                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
//                            formatter.timeZone = TimeZone(secondsFromGMT: 0)
//                            formatter.locale = Locale(identifier: "en_US_POSIX")
                            let timeString = formatter.string(from: date)
                            dictWithTransactionData[paramNameInDict] = timeString as AnyObject?
                        }
                        else  { // currency and note 
                            let valueToPass = inputField.text
                            let paramNameInDict = paramsForPostTransaction[i]
                            dictWithTransactionData[paramNameInDict] = valueToPass as AnyObject?
                        }
                    }
                }
            }
            postTransaction()
        }
        else {
            // wrong value format in input fields
        }

    }
    
    @IBAction func openChooseAccount(_ sender: UIButton) {
        performSegue(withIdentifier: chooseAccSegueIdentifier, sender: nil)
    }
    
    @IBAction func openChooseLabels(_ sender: UIButton) {
        performSegue(withIdentifier: chooseLabelsSegueIdentifier, sender: nil)
    }
    
//MARK: - Assisting Methods
    
    func showAlertOfWrongFormat() -> Bool   {
        for i in (0..<inputFieldsArray.count)    {
            let index = IndexPath.init(item: i, section: 0)
            let cell = self.transactionsTableView.cellForRow(at: index)
            for view: UIView in cell!.contentView.subviews {
                if (view is UITextField) {
                    let inputField = (view as! UITextField)
                    if !checkFieldsForCorrectFormat(text: inputField.text!, index: i) {
                        return false
                    }
                }
            }
        }
        return true
    }
    
    func checkFieldsForCorrectFormat(text: String, index: Int) -> Bool   {
        var result = true
        var errorMsg = ""
        let accountID = defaults.string(forKey: "chosenAccountID")
        let labelsArray = defaults.array(forKey: "chosenLabelsArray")
        if (index == OBTableRow.amount.rawValue && text == "")   {
            errorMsg = "Please fill up the required field(s). Required fields marked with \"*\"."
            result = false
        }
        if (accountID == nil)  {
            errorMsg = "Please choose account. Account is required field."
            result = false
        }
        else if (labelsArray == nil) {
            errorMsg = "Please choose label(s). Label(s) is required field."
            result = false
        }
        else if (index == OBTableRow.amount.rawValue) && (!text.isAmountFormat)  {
            errorMsg = "Please enter valid amount (number in format: 123.53)."
            result = false
        }
        else if (index == OBTableRow.currency.rawValue) && (text.characters.count > 3)  {
            errorMsg = "Please enter valid currency (not more than 3 characters e.g. USD)."
            result = false
        }
        else if index == OBTableRow.rate.rawValue &&
                text.characters.count > 1  &&
                !text.isAmountFormat
        {
                errorMsg = "Please enter valuid rate (rate in format: 123.53)."
                result = false
        }
        
        if !result  {
            let alert = UIAlertController(title: "Oops!", message: errorMsg, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
        }
        return result
    }

    
//MARK: UI Stuff
    func setupUI()  {
        self.transactionsTableView.tableFooterView = UIView() // remove unused cell in table view
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.applicationBoldFontOfSize(20)]
    }
}
