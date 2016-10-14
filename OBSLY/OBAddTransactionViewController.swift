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
    let chooseAccSegue = "chooseAccountSegue"
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

//MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.transactionsTableView.delegate = self
        self.transactionsTableView.dataSource = self
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
        
        // we set empty chosen account so that when user chooses the account we show chosen data
        let defaults = UserDefaults.standard
        defaults.set("Choose account", forKey: "chosenAccountName")
        defaults.set(nil, forKey: "chosenAccountID")
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
                let defaults = UserDefaults.standard
                let accountName = defaults.string(forKey: "chosenAccountName")
                print(defaults.string(forKey: "chosenAccountID"))
                accountCell.chooseAccButton.setTitle(accountName, for: .normal)
//                accountCell.chooseAccButton.setTitle("Choose account", for: .normal)
                cell = accountCell
            } else if cellID == .labels {
                let labelsCell = tableView.dequeueReusableCell(withIdentifier: chooseLabelsCellIdentifier, for: indexPath) as! OBChooseLabelsCell

                
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

    
//MARK: Actions
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func openChooseAccount(_ sender: UIButton) {
        performSegue(withIdentifier: chooseAccSegue, sender: nil)
    }
    
    @IBAction func openChooseLabels(_ sender: UIButton) {
    }
    
//MARK: UI Stuff
    func setupUI()  {
        self.transactionsTableView.tableFooterView = UIView() // remove unused cell in table view
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.applicationBoldFontOfSize(20)]
    }
}
