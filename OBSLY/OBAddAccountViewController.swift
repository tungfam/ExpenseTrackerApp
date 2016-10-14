//
//  OBAddAccountViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/27/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit
import CoreData

class OBAddAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {
   
//MARK: init
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var accountDataInputTableView: UITableView!
    let InputDataCellIdentifier = "InputDataCell"
    let InputDataTableViewCellIdentifier = "InputDataTableViewCell"
    let inputSections = 1
    let currencyRowIndexPath = IndexPath.init(row: 1, section: 0)
    let inputFieldsArray: Array = ["Name*", "Currency*", "Amount", "Sign"]
    let currencyArray = ["USD", "UAH", "EUR"]
    var pickerView = UIPickerView()
    var selectedCurrency = ""
    
    var dictWithAccountData = [String: AnyObject]()
    let paramsForPostAccount = ["name", "currency", "start_amt", "sign", "key"]
    
    var books = [NSManagedObject]()
    
//MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        accountDataInputTableView.delegate = self
        accountDataInputTableView.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
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
        return currencyArray[row]
    }
    
    
//MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return inputSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputFieldsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: InputDataTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: InputDataCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: InputDataCellIdentifier, for: indexPath) as! InputDataTableViewCell
        switch indexPath.row {
        case 1:
            let toolBar = self.returnToolBar()
            cell.fieldValue.inputAccessoryView = toolBar
            cell.fieldValue.inputView = pickerView
            cell.fieldValue.text = selectedCurrency
            break
        case 2:
            cell.fieldValue.keyboardType = UIKeyboardType.decimalPad
            break
        case 3:
            cell.fieldValue.keyboardType = UIKeyboardType.numbersAndPunctuation
            break
        default:
            break
        }
        
        cell.fieldTitle.text = inputFieldsArray[indexPath.row]
        
        return cell
    }

//MARK: Private Methods
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        if showAlertOfWrongFormat() {
            for i in (0..<4)    {
                let index = IndexPath.init(item: i, section: 0)
                let cell = self.accountDataInputTableView.cellForRow(at: index)
                for view: UIView in cell!.contentView.subviews {
                    if (view is UITextField) {
                        let inputField = (view as! UITextField)
                        // adding value to dictionary
                        if i == 2    {
                            let amountValue : Float = NSString(string: inputField.text!).floatValue
                            let paramNameInDict = paramsForPostAccount[i]
                            dictWithAccountData[paramNameInDict] = amountValue as AnyObject?
                        } else  {
                            let valueToPass = inputField.text
                            let paramNameInDict = paramsForPostAccount[i]
                            dictWithAccountData[paramNameInDict] = valueToPass as AnyObject?
                        }
                    }
                }
            }
            postAccount()
        }
        else {
            // wrong value format in input fields
        }
    }
    
    func postAccount()  {
        // adding book key param to dict
        let defaults = UserDefaults.standard
        var chosenBookKey = ""
        if let chosenBookKeyFromDefaults = defaults.string(forKey: "chosenBookKey") {
            chosenBookKey = chosenBookKeyFromDefaults
        }
        let keyParamDict = paramsForPostAccount[4]
        dictWithAccountData[keyParamDict] = chosenBookKey as AnyObject?
        print(dictWithAccountData)
        let url = NSURL(string: "http://obsly.com/api/v1/\(chosenBookKey)/accounts")
        print(url)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url! as URL)
        request.httpMethod = "POST" //set http method as POST
        do {
            let body = try JSONSerialization.data(withJSONObject: dictWithAccountData, options: JSONSerialization.WritingOptions.prettyPrinted)  // pass dictionary to nsdata object and set it as request body
            request.httpBody = body
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
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
                        self.dismiss(animated: true, completion: nil) // leaving addAccount VC
                    }
                } catch let error as NSError {
                    self.presentErrorAlert(title: "Error", error: error)
                    print("json error: \(error.localizedDescription)")
                }
            }
        })
        task.resume()
    }
    
    func setupUI()  {
        self.accountDataInputTableView.tableFooterView = UIView() // remove unused cell in table view
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.applicationBoldFontOfSize(20)]
    }
    
    
//MARK: Assisting Methods
    
    func showAlertOfWrongFormat() -> Bool   {
        for i in (0..<4)    {
            let index = IndexPath.init(item: i, section: 0)
            let cell = self.accountDataInputTableView.cellForRow(at: index)
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
        
        if ((index == 0 || index == 1) && text == "")   {
            errorMsg = "Please fill up the empty field(s)"
            result = false
        }
        if index == 1  { // currency row
            if text.characters.count > 3    {
                errorMsg = "Please enter valid currency (not more than 3 characters e.g. USD)"
                result = false
            }
        }   else if index == 2   { // amount row
            if !text.isAmountFormat {
                errorMsg = "Please enter valid amount (number in format: 123.53)"
                result = false
            }
        }
        else if index == 3    { // sign row
            if text.characters.count > 1    {
                errorMsg = "Please enter valid sign (nore more than 1 character e.g. $)"
                result = false
            }
        }
        
        if !result  {
            let alert = UIAlertController(title: "Oops!", message: errorMsg, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
            
        }
        return result
    }

    func returnToolBar() -> UIToolbar  {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(OBAddAccountViewController.reloadCurrencyTextFieldRow))
        doneButton.tintColor = UIColor(red: 255/255, green: 74/255, blue: 118/255, alpha: 1)
        
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    func reloadCurrencyTextFieldRow()   {
        let cell = accountDataInputTableView.dequeueReusableCell(withIdentifier: InputDataCellIdentifier, for: IndexPath.init(row: 1, section: 0)) as! InputDataTableViewCell
        cell.fieldValue.resignFirstResponder()
        accountDataInputTableView.reloadRows(at: [currencyRowIndexPath], with: .automatic)
    }
}
