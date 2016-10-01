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
    @IBOutlet weak var accountDataInputTableView: UITableView!
    let InputDataCellIdentifier = "InputDataCell"
    let InputDataTableViewCellIdentifier = "InputDataTableViewCell"
    let fieldsToInput = 4
    let inputSections = 1
    let currencyRowIndexPath = IndexPath.init(row: 1, section: 0)
    let inputFieldsArray: Array = ["Name", "Currency", "Amount", "Sign"]
    let currencyArray = ["USD", "UAH", "EUR"]
    var pickerView = UIPickerView()
    var selectedCurrency = ""
    
    var chosenBookIndex = 0
    var books = [NSManagedObject]()
    
//MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        accountDataInputTableView.delegate = self
        accountDataInputTableView.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Do any additional setup after loading the view.
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
        return fieldsToInput
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: InputDataTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: InputDataCellIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: InputDataCellIdentifier, for: indexPath) as! InputDataTableViewCell
        if (indexPath.row == 1) {   //currency row
            let toolBar = self.returnToolBar()
            cell.fieldValue.inputAccessoryView = toolBar
            cell.fieldValue.inputView = pickerView
            cell.fieldValue.text = selectedCurrency
        }
        cell.fieldTitle.text = inputFieldsArray[indexPath.row]
        
        return cell
    }

//MARK: Private Methods
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
    
    }
    
    internal func getChosenIndexOfBook(index: Int)  {
        chosenBookIndex = index
        print(chosenBookIndex)
        
        // getting books from coredata
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
        } else {
            print("error: old iOS version")
        }
        
        let book = books[index]
        print("add account vc")
        print(book.value(forKey: "bookName") as! String?)
        print(book.value(forKey: "bookKey") as! String?)
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
