//
//  OBLabelsViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/27/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit
import CoreData

class OBLabelsViewController: UIViewController {

//MARK: init
    
    var chosenBookIndex = 0
    var books = [NSManagedObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        print(book.value(forKey: "bookName") as! String?)
        print(book.value(forKey: "bookKey") as! String?)
    }

}