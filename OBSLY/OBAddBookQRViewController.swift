//
//  OBAddBookQRViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 10/16/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import CoreData


class OBAddBookQRViewController: UIViewController, QRCodeReaderViewControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var scannedKeyTitleLabel: UILabel!
    @IBOutlet weak var keyValueLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    var books = [NSManagedObject]()
    
    // Good practice: create the reader lazily to avoid cpu overload during the
    // initialization and each time we need to scan a QRCode
    lazy var readerVC = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
    })
    
//    weak var delegate:QRCodeReaderViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        self.nameTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        let keyValue = defaults.value(forKey: "qrScannedKey")
        if keyValue != nil  {
            self.keyValueLabel.text = keyValue as! String?
        }
    }

    
//MARK: - Actoins
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveBookAction(_ sender: Any) {
        if nameTextField.text == ""    {
            let alert = UIAlertController(title: "Oops!", message: "Please enter the book name", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else {
            let bookName = nameTextField.text
            self.saveBook(name: bookName!)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
//MARK: - Private methods
    
    func saveBook(name: String) {
        let defaults = UserDefaults.standard
        let bookKey = defaults.value(forKey: "qrScannedKey")
        if bookKey != nil  {
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
    }

    
//MARK: - UI stuff
    func setupUI()  {
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.applicationBoldFontOfSize(20)]
        self.scannedKeyTitleLabel.font = UIFont.applicationRegularFontOfSize(12)
        self.keyValueLabel.font = UIFont.applicationRegularFontOfSize(11)
        self.nameTitleLabel.font = UIFont.applicationRegularFontOfSize(20)
        self.nameTextField.font = UIFont.applicationRegularFontOfSize(20)
        
        //capitalize 1st letter
        self.nameTextField.autocapitalizationType = .sentences
    }
    

//MARK: - UI Text Field delegate
    // add the space in the end of the text field when typing 'space'
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.nameTextField) {
            let oldString = textField.text!
            let newRange = oldString.characters.index(oldString.startIndex, offsetBy: range.location)..<oldString.characters.index(oldString.startIndex, offsetBy: range.location + range.length)
            let newString = oldString.replacingCharacters(in: newRange, with: string)
            textField.text = newString.replacingOccurrences(of: " ", with: "\u{00a0}");
            return false;
        } else {
            return true;
        }
    }
    
    
//****************************** MARK: Delegate for qr code scanner
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
        
        let key = result.value
        let defaults = UserDefaults.standard
        defaults.set(key, forKey: "qrScannedKey")
        
        print(result)
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
    //
    //        dismiss(animated: true, completion: nil)
    //    }

//    func readerDidCancel(_ reader: QRCodeReader) {
//        reader.stopScanning()
//        
//        dismiss(animated: true, completion: nil)
//    }
    
//****************************** MARK: Delegate for qr code scanner

}

