//
//  OBMyBooksViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 9/7/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import QRCodeReader

class OBMyBooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, QRCodeReaderViewControllerDelegate {

//MARK: init
    @IBOutlet weak var booksListTableView: UITableView!
    
    let addBookManuallySegueIdentifier = "addBookManuallySegue"
    let addBookQRSegueIdentifier = "addBookQRSegue"
    let openBookSegueIdentifier = "openBookSegue"
    let bookCellIdentifier = "ShowDataTableViewCell"
    
    var chosenIndexPath = 0
    var books = [NSManagedObject]()
    
    
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
    })
    
//MARK: UIViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        booksListTableView.delegate = self
        navigationItem.rightBarButtonItem = editButtonItem
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            booksListTableView.reloadData()
        } else {
            print("error: old iOS version")
        }
        
    }
    
//MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: bookCellIdentifier, for: indexPath) as! ShowDataTableViewCell
        let index = (indexPath as NSIndexPath).row
        cell.titleLabel.text = "\(index + 1)."
        let book = books[indexPath.row]
        cell.valueLabel.text = book.value(forKey: "bookName") as! String?
        
        // make separator line between cells to fill full width
        cell.separatorInset = UIEdgeInsetsMake(0, 0, cell.frame.size.width, 0)
        if (cell.responds(to: #selector(getter: UIView.preservesSuperviewLayoutMargins))){
            cell.layoutMargins = UIEdgeInsets.zero
            cell.preservesSuperviewLayoutMargins = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenIndexPath = indexPath.row
        self.performSegue(withIdentifier: openBookSegueIdentifier, sender: nil)
    }

    // for deleting (editing)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // remove the deleted item from the сore data
            
            if #available(iOS 10.0, *) {
                let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                managedContext.delete(books[indexPath.row] as NSManagedObject)
                books.remove(at: indexPath.row)
                do {
                    try managedContext.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                // Delete the row from the data source
                tableView.deleteRows(at: [indexPath], with: .fade)
                // delay to reload the table
                let when = DispatchTime.now() + 0.1
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.booksListTableView.reloadData()
                }
            } else {
                print("error: old iOS version")
            }
        }
    }
    
    // for deleting (editing)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // for deleting (editing)
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        booksListTableView.setEditing(editing, animated: animated)
    }

//MARK: Private Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is OBTabBarViewController{
            let nextController = (segue.destination as! OBTabBarViewController)
            nextController.getChosenIndexOfBook(index: chosenIndexPath)
        }

    }
    
    @IBAction func showAddBookAlert(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Choose how to create a new Book", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let createBookManuallyAction = UIAlertAction(title: "Manually", style: .default, handler: {
            action in
            self.performSegue(withIdentifier: self.addBookManuallySegueIdentifier, sender: nil)
            }
        )
        let createBookQRAction = UIAlertAction(title: "Using QR-code", style: .default, handler: {
            action in
            self.scanAction(sender)
            }
        )
        alertController.addAction(createBookManuallyAction)
        alertController.addAction(createBookQRAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func setupUI()  {
        self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.applicationBoldFontOfSize(20)]
        self.automaticallyAdjustsScrollViewInsets = false // remove blank space above table view
        booksListTableView.tableFooterView = UIView() // remove unused cell in table view
        
        

    }
    
    func reloadTableView(timer: Timer)  {
        booksListTableView.reloadData()
    }

    

    
//****************************** MARK: Delegate for qr code scanner
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
        let key = result.value
        let defaults = UserDefaults.standard
        defaults.set(key, forKey: "qrScannedKey")
        print(result)
        
        //it has strange bug when you scan the code right after appearing the qr code VC then it wouldn't perform the segue. so i added this 0.1sec delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 ) {
            self.performSegue(withIdentifier: self.addBookQRSegueIdentifier, sender: nil)
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController)  {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scanAction(_ sender: AnyObject) {
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print(result)
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
//    func reader(_ reader: QRCodeReader, didScanResult result: QRCodeReaderResult) {
//        reader.stopScanning()
//        dismiss(animated: true, completion: nil)
//    }
    
//        func readerDidCancel(_ reader: QRCodeReader) {
//            reader.stopScanning()
//    
//            dismiss(animated: true, completion: nil)
//        }
    
//****************************** MARK: Delegate for qr code scanner
    
}
