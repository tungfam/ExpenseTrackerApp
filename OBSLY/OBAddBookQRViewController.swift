//
//  OBAddBookQRViewController.swift
//  OBSLY
//
//  Created by Tung Fam on 10/16/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

class OBAddBookQRViewController: UIViewController {
    @IBOutlet weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    
//MARK: - Actoins
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
//MARK: - UI stuff
    func setupUI()  {
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.applicationBoldFontOfSize(20)]
    }
}
