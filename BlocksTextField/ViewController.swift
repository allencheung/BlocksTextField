//
//  ViewController.swift
//  BlocksTextField
//
//  Created by AllenCheung on 16/10/2017.
//  Copyright © 2017 com.temp. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var inputTextField: BlocksTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.count = 4
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

