//
//  OBAddBookViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/9/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit
import CoreData

class OBAddBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//MARK: init
    @IBOutlet weak var dataInputTableView: UITableView!
    
    let InputDataCellIdentifier = "InputDataCell"
    let InputDataTableViewCellIdentifier = "InputDataTableViewCell"
    let fieldsToInput = 1
    let inputSections = 1
    
    var books = [NSManagedObject]()
    
    var bookKey: String = ""
    
//MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        dataInputTableView.delegate = self
        dataInputTableView.dataSource = self
        
        getKeyForBook()
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
        cell.fieldTitle.text = "Name*"
        
        return cell
    }
    
//MARK: Private Methods
    @available(iOS 10.0, *)
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        let index = IndexPath.init(item: 0, section: 0)
        let bookNameCell = self.dataInputTableView.cellForRow(at: index)
        
        for view: UIView in bookNameCell!.contentView.subviews {
            if (view is UITextField) {
                let bookNameField = (view as! UITextField)
                if bookNameField.text == ""    {
                    let alert = UIAlertController(title: "Oops!", message: "Please fill up the empty field(s)", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(defaultAction)
                    present(alert, animated: true, completion: nil)
                } else {
                    print(bookNameField.text)
                    let bookNameFromField = bookNameField.text!
                    self.saveBook(name: bookNameFromField)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @available(iOS 10.0, *)
    func saveBook(name: String) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity =  NSEntityDescription.entity(forEntityName: "Book", in:managedContext)
        let book = NSManagedObject(entity: entity!, insertInto: managedContext)
        book.setValue(name, forKey: "bookName")
        book.setValue(bookKey, forKey: "bookKey")
        do {
            try managedContext.save()
            self.books.append(book)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func getKeyForBook()  {
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask?
        if dataTask != nil {
            dataTask?.cancel()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let url = NSURL(string: "http://obsly.com/api/v1/key")
        dataTask = defaultSession.dataTask(with: url! as URL) {
            data, response, error in
            DispatchQueue.main.async    {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    
                    do{
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                        
                        if let result = json as? [String:AnyObject]   {
                            let temporaryBookKey = (result["key"])!
                            self.bookKey = temporaryBookKey as! String
                            print(temporaryBookKey)
                        }
                        else {
                            print("ERROR: can't find bookKey")
                        }
                    }catch {
                        print("Error with Json: \(error)")
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.bookKey = ""
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI()  {
        self.title = "New Book"
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.applicationBoldFontOfSize(20)]
        self.automaticallyAdjustsScrollViewInsets = false // remove blank space above table view
        dataInputTableView.tableFooterView = UIView() // remove unused cell in table view

    }

}
