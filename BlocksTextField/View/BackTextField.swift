//
//  BackTextField.swift
//  BlocksTextField
//
//  Created by AllenCheung on 16/10/2017.
//  Copyright © 2017 com.temp. All rights reserved.
//

import UIKit

class BackTextField: UITextField {
    override func deleteBackward() {
        super.deleteBackward()
        
        if text == nil || text?.isEmpty == true {
            let _ = delegate?.textField!(self, shouldChangeCharactersIn: NSRange.init(location: 0, length: 0), replacementString: "")
        }
    }
}
