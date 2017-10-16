//
//  SubBlockTextField.swift
//  BlocksTextField
//
//  Created by AllenCheung on 16/10/2017.
//  Copyright © 2017 com.temp. All rights reserved.
//

import UIKit
import SnapKit

class SubBlockTextField: UIView {
    var font: UIFont = UIFont.systemFont(ofSize: 18) {
        didSet {
            textField.font = font
        }
    }
    
    var textColor: UIColor = UIColor.black {
        didSet {
            textField.textColor = textColor
        }
    }
    
    var bottomLineColor: UIColor = UIColor.black {
        didSet {
            bottomLine.backgroundColor = bottomLineColor
        }
    }
    
    var text: String? {
        set {
            textField.text = newValue
        }
        get {
            return textField.text
        }
    }
    
    var keyboardType: UIKeyboardType {
        set {
            textField.keyboardType = newValue
        }
        get {
            return textField.keyboardType
        }
    }
    
    let textField: BackTextField = BackTextField()
    let bottomLine: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpViews()
    }
    
    func setUpViews() {
        textField.font = font
        textField.textColor = textColor
        textField.textAlignment = .center
        self.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        bottomLine.backgroundColor = bottomLineColor
        self.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(1.0/UIScreen.main.scale)
        }
    }
}
